function New_ActiveDirectoryServerDownException {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Function does not change system state.')]

    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param(
        [Parameter(
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Message,

        [Parameter()]
        [switch] $Throw = $false
    )

    ## LOGIC ###################################################################
    end {
        [System.Management.Automation.ErrorRecord] $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
            [System.DirectoryServices.ActiveDirectory.ActiveDirectoryServerDownException] $Message,
            'System.DirectoryServices.ActiveDirectory.ActiveDirectoryServerDownException',
            [System.Management.Automation.ErrorCategory]::ResourceUnavailable,
            $null
        )

        if ($Throw) {
            throw $ErrorRecord
        }

        $PSCmdlet.WriteObject($ErrorRecord)
    }
}
