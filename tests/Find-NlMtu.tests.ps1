Describe 'Find-NlMtu' {
    BeforeAll {
        $IPv4Properties = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() |
            Where-Object { ($_.OperationalStatus -eq 'Up') -and ($_.NetworkInterfaceType -ne 'Loopback') } |
            ForEach-Object -MemberName 'GetIPProperties' |
            Select-Object -First 1 |
            ForEach-Object -MemberName 'GetIPv4Properties'
    }

    Context 'Success' {
        It 'Type' {
            $Result = Find-NlMtu -ComputerName 'bing.com'

            $Result | Should -BeOfType [PoshToolbox.FindNlMtuCommand+NlMtuInfo]
        }

        It 'Mtu' {
            $Result = Find-NlMtu -ComputerName 'bing.com'

            $Result.NlMtu | Should -Be $IPv4Properties.Mtu
        }
    }

    Context 'Failure' {
        It 'PingException' {
            $Test = { Find-NlMtu -ComputerName 'throw.error' -ErrorAction 'Stop' }

            $Test | Should -Throw "Connection to 'throw.error' failed."
        }

        It 'PingTtlExpired' -Skip:($env:OS -ne 'Windows_NT') {
            $Test = { Find-NlMtu -ComputerName 'bing.co.kr' -MaxHops 1 -ErrorAction 'Stop' }

            $Test | Should -Throw "Connection to 'bing.co.kr' failed with status 'TtlExpired.'"
        }

        It 'PingNoReply' {
            $Test = { Find-NlMtu -ComputerName 'bing.co.kr' -Timeout 1 -ErrorAction 'Stop' }

            $Test | Should -Throw "Connection to 'bing.co.kr' failed with status 'NoReply.'"
        }
    }
}
