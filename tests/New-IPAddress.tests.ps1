Describe 'New-IPAddress' {
    Context 'Success' {
        It 'IPAddress' {
            $Result = New-IPAddress -IPAddress '169.254.0.0', 'fe80::'

            $Result | Should -BeOfType [System.Net.IPAddress]
        }

        It 'Pipeline' {
            $Result = '169.254.0.0', 'fe80::' | New-IPAddress

            $Result | Should -BeOfType [System.Net.IPAddress]
        }
    }

    Context 'Failure' {
        It 'FormatException' {
            $Test = { New-IPAddress -IPAddress 'ThrowError' -ErrorAction Stop }

            $Test | Should -Throw 'An invalid IP address was specified.'
        }
    }
}
