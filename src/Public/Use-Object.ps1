function Use-Object {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([object])]

    param (
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [AllowNull()]
        [object] $InputObject,

        [Parameter(
            Mandatory,
            Position = 1
        )]
        [scriptblock] $ScriptBlock
    )

    ## LOGIC ###################################################################
    end {
        try {
            $ScriptBlock.InvokeWithContext(
                $null,
                [psvariable]::new('_', $InputObject),
                $null
            )
        } catch {
            throw $_
        } finally {
            foreach ($Object in $InputObject) {
                if ($Object -is [System.IDisposable]) {
                    $Object.Dispose()
                } elseif ([System.Runtime.InteropServices.Marshal]::IsComObject($Object)) {
                    $null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($Object)
                }
            }
        }
    }
}
