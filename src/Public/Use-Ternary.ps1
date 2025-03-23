function Use-Ternary {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [Alias("?:")]
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
        [object]
        $IfTrue,

        [Parameter(
            Position = 1,
            Mandatory
        )]
        [object]
        $IfFalse
    )

    ## PROCESS ################################################################
    process {
        # wrapping in an array to handle $null as input
        foreach ($Object in @($InputObject)) {
            try {
                if ($Object -and ($IfTrue -is [scriptblock])) {
                    . $IfTrue
                } elseif ($Object) {
                    Write-Output $IfTrue -NoEnumerate
                } elseif ($IfFalse -is [scriptblock]) {
                    . $IfFalse
                } else {
                    Write-Output $IfFalse -NoEnumerate
                }
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
