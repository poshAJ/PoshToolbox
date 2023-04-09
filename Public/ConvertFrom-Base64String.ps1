# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

using namespace System.IO

function ConvertFrom-Base64String {
    [CmdletBinding(
        SupportsShouldProcess,
        DefaultParameterSetName = "Path"
    )]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline,
            ParameterSetName = "Path"
        )]
        [ValidateScript({
                if (Test-Path -Path $_ -PathType Leaf) {
                    return $true
                }
                throw "The argument specified must resolve to a valid file path."
            })]
        [string[]]
        $Path,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "LiteralPath"
        )]
        [Alias("PSPath")]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -PathType Leaf) {
                    return $true
                }
                throw "The argument specified must resolve to a valid file path."
            })]
        [string[]]
        $LiteralPath,

        [Parameter(
            Mandatory,
            ParameterSetName = "InputObject"
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $InputObject,

        [Parameter()]
        [switch]
        $AsBytes
    )

    dynamicparam {
        $Attribute = ($InputObject -and -not $AsBytes) | ?: { [Management.Automation.ParameterAttribute] @{ Mandatory = $true } } { [Management.Automation.ParameterAttribute] @{} }
        $Validate = [Management.Automation.ValidateScriptAttribute] {
            if (Test-Path -LiteralPath $_ -IsValid) {
                return $true
            }
            throw "The argument specified must resolve to a valid file or folder path."
        }

        $Collection = [Collections.ObjectModel.Collection[Attribute]]::new()
        $Collection.Add($Attribute)
        $Collection.Add($Validate)

        $Parameter = [Management.Automation.RuntimeDefinedParameter]::new("Destination", [string], $Collection)
        $PSBoundParameters["Destination"] = (Get-Location -PSProvider FileSystem).ProviderPath

        $Dictionary = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $Dictionary.Add("Destination", $Parameter)

        return $Dictionary
    }

    ## BEGIN ##################################################################
    begin {
        $Destination = $PSBoundParameters["Destination"]
        $DestinationInfo = [FileInfo] (Resolve-PoshPath -LiteralPath $Destination).ProviderPath
    }

    ## PROCESS ################################################################
    process {
        $Process = switch -Regex ($PSCmdlet.ParameterSetName) {
            "InputObject" { @{String = $InputObject } }
            "LiteralPath" { Resolve-PoshPath -LiteralPath $LiteralPath }
            default { Resolve-PoshPath -Path $Path }
        }

        foreach ($Object in $Process) {
            try {
                if ($PSCmdlet.ParameterSetName -eq "InputObject") {
                    $String = $Object.String
                } elseif ($Object.Provider.Name -ne "FileSystem") {
                    New-ArgumentException "The argument specified must resolve to a valid path on the FileSystem provider." -Throw
                } else {
                    $File = [FileInfo] $Object.ProviderPath

                    Write-Verbose ("READ {0}" -f $File)
                    $String = [File]::ReadAllText($File)
                }

                $Bytes = [Convert]::FromBase64String($String)

                if ($AsBytes) {
                    Write-Output $Bytes
                } else {
                    $CalculatedDestination = $DestinationInfo.Extension | ?: { $DestinationInfo } { "{0}\{1}" -f $DestinationInfo.FullName.TrimEnd("\"), $File.BaseName }

                    if ($PSCmdlet.ShouldProcess($CalculatedDestination, "Write Content")) {
                        if (-not ($Directory = $DestinationInfo.Extension | ?: { $DestinationInfo.Directory } { $DestinationInfo }).Exists) {
                            $null = [Directory]::CreateDirectory($Directory)
                        }

                        Write-Verbose ("WRITE {0}" -f $CalculatedDestination)
                        [File]::WriteAllBytes($CalculatedDestination, $Bytes)

                        Write-Output (Get-ChildItem -Path $CalculatedDestination)
                    }
                }
                ## EXCEPTIONS #################################################
            } catch [System.Management.Automation.MethodInvocationException] {
                $PSCmdlet.WriteError(( New-MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }

    ## END ####################################################################
    end {
    }
}
