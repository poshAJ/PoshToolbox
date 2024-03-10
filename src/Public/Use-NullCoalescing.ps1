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
        [scriptblock]
        $IfNull
    )

    ## PROCESS ################################################################
    process {
        # wrapping in an array to handle $null as input
        foreach ($Object in @($InputObject)) {
            try {
                if ($null -eq $Object) {
                    . $IfNull
                } else {
                    Write-Output $Object
                }
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
