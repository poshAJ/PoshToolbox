function Use-NullCoalescing {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [Alias("??")]
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
        $IfNull
    )

    ## END ####################################################################
    end {
        if (-not ($InputObject = $input)) {
            $InputObject = , $null
        }

        foreach ($Object in $InputObject) {
            try {
                if (($null -eq $Object) -and ($IfNull -is [scriptblock])) {
                    . $IfNull
                } elseif ($null -eq $Object) {
                    Write-Output $IfNull -NoEnumerate
                } else {
                    Write-Output $Object -NoEnumerate
                }
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
