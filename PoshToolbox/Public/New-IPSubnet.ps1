# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

function New-IPSubnet {
    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = "InputObject"
        )]
        [string[]]
        $InputObject,

        [Alias("Address")]
        [Parameter(
            Mandatory,
            ParameterSetName = "IPAddress"
        )]
        [string]
        $IPAddress,

        [Alias("Prefix")]
        [Parameter(
            Mandatory,
            ParameterSetName = "IPAddress"
        )]
        [int]
        $IPPrefix
    )

    ## PROCESS ################################################################
    process {
        foreach ($Object in $PSBoundParameters[$PSCmdlet.ParameterSetName]) {
            try {
                if ($PSCmdlet.ParameterSetName -eq "InputObject") {
                    $IPAddress = ($Object -isplit "\\|\/")[0]
                    $IPPrefix = ($Object -isplit "\\|\/")[-1]
                }

                Write-Output ([ipsubnet]::Parse($IPAddress, $IPPrefix))

                ## EXCEPTIONS #################################################
            } catch [System.Management.Automation.MethodException] {
                $PSCmdlet.WriteError(( New-MethodInvocationException -Exception $_.Exception.InnerException.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
