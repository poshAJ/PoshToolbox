# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

using namespace System.Management.Automation
using namespace System.DirectoryServices.ActiveDirectory

function New-ActiveDirectoryServerDownException {
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
            [ActiveDirectoryServerDownException]::new($Message),
            "System.DirectoryServices.ActiveDirectory.ActiveDirectoryServerDownException",
            [ErrorCategory]::ResourceUnavailable,
            $null
        )

        if ($Throw) {
            throw $ErrorRecord
        }

        Write-Output $ErrorRecord
    }
}
