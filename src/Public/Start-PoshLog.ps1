function Start-PoshLog {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'As designed to receive log events.')]

    [CmdletBinding(DefaultParameterSetName = "Path")]
    [OutputType([void])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "Path"
        )]
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "PathAppend"
        )]
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "PathNoClobber"
        )]
        [ValidateScript({
                if (Test-Path -Path $_ -IsValid) {
                    return $true
                }
                throw "The argument specified must resolve to a valid file or folder path."
            })]
        [string[]]
        $Path = [Environment]::GetFolderPath("MyDocuments"),

        [Alias("PSPath")]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "LiteralPath"
        )]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "LiteralPathAppend"
        )]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "LiteralPathNoClobber"
        )]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -IsValid) {
                    return $true
                }
                throw "The argument specified must resolve to a valid file or folder path."
            })]
        [string[]]
        $LiteralPath,

        [Parameter(ParameterSetName = "PathAppend")]
        [Parameter(ParameterSetName = "LiteralPathAppend")]
        [switch]
        $Append,

        [Parameter(ParameterSetName = "PathNoClobber")]
        [Parameter(ParameterSetName = "LiteralPathNoClobber")]
        [switch]
        $NoClobber,

        [Parameter()]
        [switch]
        $AsUtc,

        [Parameter()]
        [switch]
        $PassThru
    )

    ## BEGIN ##################################################################
    begin {
        $DateTime = [datetime]::Now

        $Format = $AsUtc | Use-Ternary { "yyyy\-MM\-dd HH:mm:ss\Z", "ToUniversalTime", "yyyyMMdd\-HHmmss\Z" } { "yyyy\-MM\-dd HH:mm:ss", "ToLocalTime", "yyyyMMdd\-HHmmss" }
        $FileMode = $Append | Use-Ternary { [System.IO.FileMode]::Append } { $NoClobber | Use-Ternary { [System.IO.FileMode]::CreateNew } { [System.IO.FileMode]::Create } }

        $Template = {
            "**********************"
            "Windows PowerShell log start"
            "Version: {0} ({1})" -f $PSVersionTable.PSVersion, $PSVersionTable.PSEdition
            "Start time: {0:$( $Format[0] )}" -f $DateTime.($Format[1]).Invoke()
            "**********************"
        }
    }

    ## PROCESS ################################################################
    process {
        $Process = ($PSCmdlet.ParameterSetName -cmatch "^LiteralPath") | Use-Ternary { Resolve-PoshPath -LiteralPath $LiteralPath } { Resolve-PoshPath -Path $Path }

        foreach ($Object in $Process) {
            try {
                if ($Object.Provider.Name -ne "FileSystem") {
                    New-ArgumentException "The argument specified must resolve to a valid path on the FileSystem provider." -Throw
                }

                $FileInfo = [System.IO.FileInfo] $Object.ProviderPath

                if (-not ($Directory = $FileInfo.Extension | Use-Ternary { $FileInfo.Directory } { $FileInfo }).Exists) {
                    $null = [System.IO.Directory]::CreateDirectory($Directory)
                }

                if (-not $FileInfo.Extension) {
                    $FileInfo = [System.IO.FileInfo] ("PowerShell_log.{0}.{1:$( $Format[2] )}.txt" -f ([guid]::NewGuid() -isplit "-")[0], $DateTime.($Format[1]).Invoke())
                }

                Use-Object ($File = [System.IO.File]::Open($Directory.FullName + "\" + $FileInfo.Name, $FileMode)) {
                    if ($Append) {
                        $NewLine = [System.Text.Encoding]::UTF8.GetBytes([System.Environment]::NewLine)
                        $File.Write($NewLine, 0, $NewLine.Length)
                    }

                    foreach ($Line in $Template.Invoke()) {
                        $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Line + [System.Environment]::NewLine)
                        $File.Write($Bytes, 0, $Bytes.Length)
                    }
                }

                $Global:PSLogDetails += @(@{ Path = $File.Name; Utc = $AsUtc })
                Write-Information -InformationAction Continue -MessageData ("Log started, output file is '{0}'" -f $File.Name) -InformationVariable null

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
        if (-not (Get-EventSubscriber | Where-Object SourceIdentifier -CMatch "^PSLog") -and $PSLogDetails) {
            $Global:PSLogInformation = [System.Collections.ObjectModel.ObservableCollection[System.Management.Automation.InformationRecord]]::new()
            $Global:PSLogWarning = [System.Collections.ObjectModel.ObservableCollection[System.Management.Automation.WarningRecord]]::new()
            $Global:PSLogError = [System.Collections.ObjectModel.ObservableCollection[System.Management.Automation.ErrorRecord]]::new()

            $Action = { Write-PoshLog -PSEventArgs $Event }

            $null = Register-ObjectEvent -EventName CollectionChanged -InputObject $PSLogInformation -SourceIdentifier PSLogInformation -Action $Action
            $null = Register-ObjectEvent -EventName CollectionChanged -InputObject $PSLogWarning -SourceIdentifier PSLogWarning -Action $Action
            $null = Register-ObjectEvent -EventName CollectionChanged -InputObject $PSLogError -SourceIdentifier PSLogError -Action $Action

            $Global:PSDefaultParameterValues["Write-Information:InformationVariable"] = "+PSLogInformation"
            $Global:PSDefaultParameterValues["Write-Warning:WarningVariable"] = "+PSLogWarning"
            $Global:PSDefaultParameterValues["Write-Error:ErrorVariable"] = "+PSLogError"
        }

        if ($PassThru) {
            Write-Output (, $PSLogDetails.Path)
        }
    }
}
