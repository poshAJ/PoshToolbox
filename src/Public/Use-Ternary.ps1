function Use-Ternary {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [Alias('?:')]
    [OutputType([object])]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [object] $InputObject,

        [Parameter(
            Position = 0
        )]
        [object] $IfTrue,

        [Parameter(
            Position = 1
        )]
        [object] $IfFalse
    )

    ## LOGIC ###################################################################
    process {
        foreach ($Object in , $InputObject) {
            try {
                [object] $Output = if ($Object) { $IfTrue } else { $IfFalse }

                if ($Output -is [scriptblock]) {
                    . $Output
                } else {
                    $PSCmdlet.WriteObject($Output)
                }
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
