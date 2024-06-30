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
            Mandatory,
            Position = 0
        )]
        [object] $IfTrue,

        [Parameter(
            Mandatory,
            Position = 1
        )]
        [object] $IfFalse
    )

    ## LOGIC ###################################################################
    process {
        foreach ($Object in , $InputObject) {
            try {
                if ($Object) {
                    Write_Object $IfTrue
                } else {
                    Write_Object $IfFalse
                }
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
