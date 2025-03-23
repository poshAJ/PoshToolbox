# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

using namespace System.IO

function Split-File {
    [CmdletBinding(SupportsShouldProcess)]
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

        [Parameter()]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -IsValid) {
                    return $true
                }
                throw "The argument specified must resolve to a valid file or folder path."
            })]
        [string]
        $Destination = (Get-Location -PSProvider FileSystem).ProviderPath,

        [Parameter (
            Mandatory
        )]
        [ValidateRange(0, [int32]::MaxValue)]
        [int32]
        $Size
    )

    ## BEGIN ##################################################################
    begin {
        $DestinationInfo = [FileInfo] (Resolve-PoshPath -LiteralPath $Destination).ProviderPath
    }

    ## PROCESS ################################################################
    process {
        $Process = ($PSCmdlet.ParameterSetName -cmatch "^LiteralPath") | ?: { Resolve-PoshPath -LiteralPath $LiteralPath } { Resolve-PoshPath -Path $Path }

        foreach ($Object in $Process) {
            try {
                if ($Object.Provider.Name -ne "FileSystem") {
                    New-ArgumentException "The argument specified must resolve to a valid path on the FileSystem provider." -Throw
                }

                $File = [FileInfo] $Object.ProviderPath

                Write-Verbose ("READ {0}" -f $File)
                Use-Object ($Reader = [File]::OpenRead($File)) {
                    $Buffer = [byte[]]::new($Size)
                    $Count = 1

                    $CalculatedDestination = $DestinationInfo.Extension | ?: { "{0}\{1}" -f $DestinationInfo.Directory.FullName, $File.Name } { "{0}\{1}" -f $DestinationInfo.FullName.TrimEnd("\"), $File.Name }

                    while ($Read = $Reader.Read($Buffer, 0, $Buffer.Length)) {
                        if ($Read -ne $Buffer.Length) {
                            [array]::Resize([ref] $Buffer, $Read)
                        }

                        $SplitFile = "{0}.{1}split" -f $CalculatedDestination, $Count
                        if ($PSCmdlet.ShouldProcess($SplitFile, "Write Content")) {
                            if (-not ($Directory = $DestinationInfo.Extension | ?: { $DestinationInfo.Directory } { $DestinationInfo }).Exists) {
                                $null = [Directory]::CreateDirectory($Directory)
                            }

                            Write-Verbose ("WRITE {0}" -f $SplitFile)
                            [File]::WriteAllBytes($SplitFile, $Buffer)
                        }

                        $Count++
                    }

                    # sort to fix ChildItem number sorting
                    Write-Output (Get-ChildItem -Path ("{0}.*split" -f $CalculatedDestination) | Sort-Object -Property @{e = { [int32] [regex]::Match($_.FullName, "\.(\d+)split$").Groups[1].Value } })
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
