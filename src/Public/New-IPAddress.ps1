function New-IPAddress {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Function does not change system state.')]

    [CmdletBinding()]
    [OutputType([object])]
    param (
        [Alias('Address')]
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        [string[]] $IPAddress
    )

    ## LOGIC ###################################################################
    process {
        foreach ($Address in $IPAddress) {
            try {
                $PSCmdlet.WriteObject([System.Net.IPAddress]::Parse($Address))

                ## EXCEPTIONS ##################################################
            } catch [System.Management.Automation.MethodInvocationException] {
                $PSCmdlet.WriteError(( New_MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
