function Invoke-ExponentialBackoff {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([object])]

    param (
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [scriptblock] $ScriptBlock,

        [Parameter()]
        [int32] $RetryCount = 3,

        [Parameter()]
        [int32] $Base = 2,

        [Parameter()]
        [int32] $Scalar = 1
    )

    ## LOGIC ###################################################################
    end {
        for ([int32] $i = 0; $i -lt $RetryCount; $i++) {
            try {
                . $ScriptBlock

                return
            } catch {
                $PSCmdlet.WriteError($_)

                if (($i + 1) -ge $RetryCount) {
                    $PSCmdlet.ThrowTerminatingError(( New_LimitException -Message "The operation has reached the limit of ${RetryCount} retries." ))
                }

                Start-Sleep -Milliseconds ((Get-Random -Maximum 1000) * $Scalar * [bigint]::Pow($Base, $i))
            }
        }
    }
}
