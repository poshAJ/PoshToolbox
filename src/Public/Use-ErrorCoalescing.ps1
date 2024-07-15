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
                [System.Management.Automation.ErrorRecord] $ErrorRecord = $_

                [object] $Output = if ($IfError -is [System.Collections.IDictionary]) {
                    $IfError.GetEnumerator().Where{ $ErrorRecord.Exception -is $_.Key }[0].Value
                } else {
                    $IfError
                }

                if ($Output -is [scriptblock]) {
                    $Output.InvokeWithContext(
                        $null,
                        [psvariable]::new('_', $ErrorRecord),
                        $null
                    )
                } else {
                    $PSCmdlet.WriteObject($Output)
                }
            }
        }
    }
}
