# Copyright (c) 2022 Anthony J. Raymond, MIT License (see manifest for details)

function Use-NullCoalescing {
    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [object]
        $InputObject,

        [Parameter(
            Position = 0,
            Mandatory
        )]
        [scriptblock]
        $IfNull
    )

    ## PROCESS ################################################################
    process {
        # wrapping in an array to handle $null as input
        :Main foreach ($Object in @($InputObject)) {
            try {
                if ($null -eq $Object) {
                    . $IfNull
                } else {
                    Write-Output $Object
                }
            } catch {
                $PSCmdlet.WriteError($_)
                continue Main
            }
        }
    }
}


Set-Alias -Name ?? -Value Use-NullCoalescing
