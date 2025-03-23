# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

using namespace System.Management.Automation

function New-ArgumentException {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]

    ## PARAMETERS #############################################################
    param(
        [Parameter(
            Position = 0,
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message,

        [Parameter()]
        [switch]
        $Throw
    )

    ## PROCESS ################################################################
    process {
        $ErrorRecord = [ErrorRecord]::new(
            [ArgumentException]::new($Message),
            "System.ArgumentException",
            [ErrorCategory]::InvalidArgument,
            $null
        )

        if ($Throw) {
            throw $ErrorRecord
        }

        Write-Output $ErrorRecord
    }
}
