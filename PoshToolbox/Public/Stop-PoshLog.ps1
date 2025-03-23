# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

function Stop-PoshLog {
    [CmdletBinding()]
    [OutputType([void])]

    ## PARAMETERS #############################################################
    param ()

    ## BEGIN ##################################################################
    begin {
        if (-not $PSLogDetails) {
            $PSCmdlet.ThrowTerminatingError(( New-PSInvalidOperationException -Message "An error occurred stopping the log: The host is not currently logging." ))
        }

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

    ## PROCESS ################################################################
    process {
        foreach ($PSLog in $PSLogDetails) {
            try {
                $Format = $PSLog.Utc | ?: { "yyyy\-MM\-dd HH:mm:ss\Z", "ToUniversalTime" } { "yyyy\-MM\-dd HH:mm:ss", "ToLocalTime" }

                Use-Object ($File = [System.IO.File]::AppendText($PSLog.Path)) {
                    foreach ($Line in $Template.Invoke()) {
                        $File.WriteLine($Line)
                    }
                }

                Write-Information -InformationAction Continue -MessageData ("Log stopped, output file is '{0}'" -f $PSLog.Path) -InformationVariable null

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
        Remove-Variable -Name PSLog* -Scope Global
    }
}
