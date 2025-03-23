function Use-Object {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            Mandatory
        )]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [AllowNull()]
        [object]
        $InputObject,

        [Parameter(
            Position = 1,
            Mandatory
        )]
        [scriptblock]
        $ScriptBlock
    )

    ## PROCESS ################################################################
    process {
        try {
            . $ScriptBlock
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
