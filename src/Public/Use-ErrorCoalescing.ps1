function Use-ErrorCoalescing {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [Alias('?!')]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [scriptblock]
        $InputObject,

        [Parameter(
            Position = 0
        )]
        [AllowNull()]
        [object]
        $IfError
    )

    ## PROCESS ################################################################
    process {
        # wrapping in an array to handle $null as input
        foreach ($Object in , $InputObject) {
            try {
                . $Object
            } catch {
                $Exception = $_.Exception

                if ($IfError -is [scriptblock]) {
                    . $IfError
                } elseif ($IfError -is [hashtable]) {
                    foreach ($Catch in $IfError.GetEnumerator()) {
                        if (($Condition = $Exception -is $Catch.Name) -and ($Catch.Value -is [scriptblock])) {
                            . $Catch.Value
                        } elseif ($Condition) {
                            Write-Output (, $Catch.Value)
                        }
                    }
                } else {
                    Write-Output (, $IfError)
                }
            }
        }
    }
}
