function New-IPSubnet {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Function does not change system state.')]

    [CmdletBinding()]
    [OutputType([System.Net.IPSubnet])]
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ParameterSetName = 'InputObject'
        )]
        [string[]] $InputObject,

        [Alias('Address')]
        [Parameter(
            Mandatory,
            ParameterSetName = 'IPAddress'
        )]
        [string] $IPAddress,

        [Alias('Prefix')]
        [Parameter(
            Mandatory,
            ParameterSetName = 'IPAddress'
        )]
        [int32] $IPPrefix
    )

    ## LOGIC ###################################################################
    process {
        foreach ($Object in $PSBoundParameters[$PSCmdlet.ParameterSetName]) {
            try {
                if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                    $IPAddress = ($Object -isplit '\\|\/')[0]
                    $IPPrefix = ($Object -isplit '\\|\/')[-1]
                }

                $PSCmdlet.WriteObject([System.Net.IPSubnet]::Parse($IPAddress, $IPPrefix))
            } catch [System.Management.Automation.MethodException] {
                $PSCmdlet.WriteError(( New_MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
