function Use-Ternary {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [Alias('?:')]
    [OutputType([object])]

    ## PARAMETERS ##############################################################
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

    ## PROCESS #################################################################
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
