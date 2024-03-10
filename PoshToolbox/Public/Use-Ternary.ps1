# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

function Use-Ternary {
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
        $IfTrue,

        [Parameter(
            Position = 1,
            Mandatory
        )]
        [scriptblock]
        $IfFalse
    )

    ## PROCESS ################################################################
    process {
        # wrapping in an array to handle $null as input
        foreach ($Object in @($InputObject)) {
            try {
                if ($Object) {
                    . $IfTrue
                } else {
                    . $IfFalse
                }
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
