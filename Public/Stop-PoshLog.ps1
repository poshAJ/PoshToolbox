# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

using namespace System.IO
using namespace System.Management.Automation

function Stop-PoshLog {
    [CmdletBinding()]
    [OutputType([void])]

    ## PARAMETERS #############################################################
    param (
    )

    ## BEGIN ##################################################################
    begin {
        if (-not $PSLogDetails) {
            $PSCmdlet.ThrowTerminatingError(
                [ErrorRecord]::new(
                    ([PSInvalidOperationException] "An error occurred stopping the log: The host is not currently logging."),
                    "InvalidOperation",
                    [ErrorCategory]::InvalidOperation,
                    $null
                )
            )
        } else {
            if ($Events = Get-EventSubscriber | Where-Object SourceIdentifier -CMatch "^PSLog") {
                $Events | Unregister-Event

                $Global:PSDefaultParameterValues.Remove("Write-Information:InformationVariable")
                $Global:PSDefaultParameterValues.Remove("Write-Warning:WarningVariable")
                $Global:PSDefaultParameterValues.Remove("Write-Error:ErrorVariable")
            }

            $DateTime = [datetime]::Now

            $Template = {
                "**********************"
                "Windows PowerShell log end"
                "End time: {0:$( $Format[0] )}" -f $DateTime.($Format[1]).Invoke()
                "**********************"
            }
        }
    }

    ## PROCESS ################################################################
    process {
        :Main foreach ($PSLog in $PSLogDetails) {
            try {
                $Format = $PSLog.Utc | ?: { "yyyy\-MM\-dd HH:mm:ss\Z", "ToUniversalTime" } { "yyyy\-MM\-dd HH:mm:ss", "ToLocalTime" }

                Use-Object ($File = [File]::AppendText($PSLog.Path)) {
                    foreach ($Line in $Template.Invoke()) {
                        $File.WriteLine($Line)
                    }
                }

                Write-Information -InformationAction Continue -MessageData "Log stopped, output file is '$( $PSLog.Path )'" -InformationVariable null
                ## EXCEPTIONS #################################################
            } catch [MethodInvocationException] {
                $PSCmdlet.WriteError(
                    [ErrorRecord]::new(
                        $_.Exception.InnerException,
                        "MethodException",
                        [ErrorCategory]::InvalidOperation,
                        $PSLog
                    )
                )
                continue Main
            } catch {
                $PSCmdlet.WriteError($_)
                continue Main
            }
        }
    }

    ## END ####################################################################
    end {
        Remove-Variable -Name PSLog* -Scope Global
    }
}
