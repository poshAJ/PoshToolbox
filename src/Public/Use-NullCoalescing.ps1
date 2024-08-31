function Use-NullCoalescing {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [Alias('??')]
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
        [object] $IfNull
    )

    ## LOGIC ###################################################################
    end {
        if (-not ($InputObject = $input)) {
            $InputObject = , $null
        }

        foreach ($Object in $InputObject) {
            try {
                if ($null -eq $Object) {
                    if ($IfNull -is [scriptblock]) {
                        . $IfNull
                    } else {
                        $PSCmdlet.WriteObject($IfNull)
                    }
                } else {
                    $PSCmdlet.WriteObject($Object)
                }
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
