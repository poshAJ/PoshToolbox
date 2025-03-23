# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

using namespace System.IO

function Write-PoshLog {
    [CmdletBinding(
        DefaultParameterSetName = "Type"
    )]
    [OutputType([void])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory,
            DontShow,
            ParameterSetName = "PSEventArgs"
        )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSEventArgs]
        $PSEventArgs,

        [Parameter(
            ParameterSetName = "Type"
        )]
        [ValidateSet("Log", "Information", "Warning", "Error")]
        [string]
        $Type = "Log",

        [Parameter(
            Position = 0,
            Mandatory,
            ParameterSetName = "Type"
        )]
        [string]
        $Message
    )

    ## BEGIN ##################################################################
    begin {
        if (-not $PSLogDetails) {
            New-PSInvalidOperationException -Message "An error occurred writing the log: The host is not currently logging." -Throw
        } else {
            $TypeMap = @{
                Log         = "LOG"
                Information = "INFO"
                Warning     = "WARN"
                Error       = "ERROR"
            }

            $Template = {
                "{0:$( $Format[0] )}`t[{1}]`t{2}" -f $DateTime.($Format[1]).Invoke(), $TypeMap.$Type, $Message
            }

            if ($PSEventArgs) {
                $DateTime = $PSEventArgs.TimeGenerated

                switch ($PSEventArgs.SourceIdentifier) {
                    "PSLogInformation" {
                        $Type = "Information"
                        $Message = $PSEventArgs.SourceEventArgs.NewItems.MessageData
                    }
                    "PSLogWarning" {
                        $Type = "Warning"
                        $Message = $PSEventArgs.SourceEventArgs.NewItems.Message
                    }
                    "PSLogError" {
                        $Type = "Error"
                        $Message = $PSEventArgs.SourceEventArgs.NewItems.Exception.Message
                    }
                }
            } else {
                $DateTime = [datetime]::Now
            }
        }
    }

    ## PROCESS ################################################################
    process {
        foreach ($PSLog in $PSLogDetails) {
            try {
                $Format = $PSLog.Utc | ?: { "yyyy\-MM\-dd HH:mm:ss\Z", "ToUniversalTime" } { "yyyy\-MM\-dd HH:mm:ss", "ToLocalTime" }

                Use-Object ($File = [File]::AppendText($PSLog.Path)) {
                    $File.WriteLine($Template.Invoke()[0])
                }

                ## EXCEPTIONS #################################################
            } catch [MethodInvocationException] {
                $PSCmdlet.WriteError((New-MethodInvocationException -Exception $_.Exception.InnerException))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }

    ## END ####################################################################
    end {
    }
}
