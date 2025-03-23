function Use-ErrorCoalescing {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [Alias('?!')]
    [OutputType([object])]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [scriptblock] $InputObject,

        [Parameter(
            Position = 0
        )]
        [AllowNull()]
        [object] $IfError
    )

    ## LOGIC ###################################################################
    process {
        foreach ($Object in , $InputObject) {
            try {
                . $Object
            } catch {
                $Exception = $_.Exception

                if ($IfError -is [System.Collections.IDictionary]) {
                    foreach ($Catch in $IfError.GetEnumerator()) {
                        if ($Exception -is $Catch.Name) {
                            Write_Object $Catch.Value
                        }
                    }
                } else {
                    Write_Object $IfError
                }
            }
        }
    }
}
