# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

function Invoke-ExponentialBackoff {
    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            Mandatory
        )]
        [scriptblock]
        $ScriptBlock,

        [Parameter()]
        [int]
        $RetryCount = 3,

        [Parameter()]
        [int]
        $Base = 2,

        [Parameter()]
        [int]
        $Scalar = 1
    )

    ## PROCESS ################################################################
    process {
        for ([int] $i = 0; $i -lt $RetryCount; $i++) {
            try {
                . $ScriptBlock
                break
            } catch {
                $PSCmdlet.WriteError($_)

                if (($i + 1) -ge $RetryCount) {
                    $PSCmdlet.ThrowTerminatingError(( New-ExponentialBackoffLimitException -Message ("The operation has reached the limit of {0} retries." -f $RetryCount) ))
                }

                Start-Sleep -Milliseconds ((Get-Random -Maximum 1000) * $Scalar * [math]::Pow($Base, $i))
            }
        }
    }
}
