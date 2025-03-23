function Find-NlMtu {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectUsageOfAssignmentOperator', '',
        Justification = 'Assignment Operator is intended.')]

    [CmdletBinding()]
    [OutputType([PoshToolbox.FindNlMtuCommand+NlMtuInfo])]

    param (
        [Alias('Hostname', 'IPAddress', 'Address')]
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $ComputerName,

        [Parameter()]
        [ValidateRange(1, [int32]::MaxValue)]
        [int32] $Timeout = 10000,

        [Alias('Ttl', 'TimeToLive', 'Hops')]
        [Parameter()]
        [ValidateRange(1, [int32]::MaxValue)]
        [int32] $MaxHops = 128
    )

    ## LOGIC ###################################################################
    begin {
        [System.Net.NetworkInformation.PingOptions] $PingOptions = @{
            'Ttl'          = $MaxHops
            'DontFragment' = $true
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            try {
                [System.Collections.Generic.Dictionary[string, System.IDisposable]] $Disposable = @{}

                $Disposable.Ping = [System.Net.NetworkInformation.Ping]::new()
                [uint16] $UpperBound = 65535
                [uint16] $LowerBound = 1

                [int32] $Size = 9000
                [byte[]] $Buffer = [byte[]]::new($Size)

                [System.Collections.Generic.List[System.Net.NetworkInformation.PingReply]] $Result = @()

                while ($Size -ne $LowerBound) {
                    try {
                        $PSCmdlet.WriteVerbose("PING ${Computer} with ${Size}-byte payload")

                        [System.Net.NetworkInformation.PingReply] $Reply = $Disposable.Ping.Send($Computer, $Timeout, $Buffer, $PingOptions)
                    } catch {
                        New_InvalidOperationException -Message "Connection to '${Computer}' failed." -Throw
                    }

                    switch ($Reply.Status) {
                        'PacketTooBig' { $UpperBound = $Size }
                        'Success' { $LowerBound = $Size }
                        'TimedOut' { $UpperBound = $Size }
                        default {
                            New_InvalidOperationException -Message "Connection to '${Computer}' failed with status '$( $Reply.Status ).'" -Throw
                        }
                    }

                    $Result.Add($Reply)

                    if (($Size = [System.Math]::Floor(($LowerBound + $UpperBound) / 2)) -eq 1) {
                        New_InvalidOperationException -Message "Connection to '${Computer}' failed with status 'NoReply.'" -Throw
                    }

                    [array]::Resize([ref] $Buffer, $Size)
                }

                if (([int32] $Hops = $MaxHops - $Result.Where{ $_.Status -eq 'Success' }[-1].Options.Ttl) -lt 0) {
                    $Hops = 0
                }

                $PSCmdlet.WriteObject(
                    [PoshToolbox.FindNlMtuCommand+NlMtuInfo]::new(
                        $Computer,
                        $Result.Where{ $_.Status -eq 'Success' }[-1].Address,
                        [int64] ($Result.Where{ $_.Status -eq 'Success' }.RoundtripTime | Measure-Object -Average).Average,
                        $Hops,
                        $Size + 28 # IP Header (20 bytes) + ICMP Header (8 bytes) = 28 bytes
                    )
                )
            } catch {
                $PSCmdlet.WriteError($_)
            } finally {
                $Disposable.Values.Dispose()
            }
        }
    }
}
