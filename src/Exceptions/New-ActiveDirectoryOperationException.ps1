function New-ActiveDirectoryOperationException {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification='Function does not change system state.')]

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
        $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
            [System.DirectoryServices.ActiveDirectory.ActiveDirectoryOperationException]::new($Message),
            "System.DirectoryServices.ActiveDirectory.ActiveDirectoryOperationException",
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $null
        )

        if ($Throw) {
            throw $ErrorRecord
        }

        Write-Output $ErrorRecord
    }
}
