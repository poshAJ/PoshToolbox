Describe "New-IPSubnet" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "IPAddressV4" {
            $Result = New-IPSubnet -IPAddress "169.254.0.0" -IPPrefix 16 | Get-Member

            $Result.TypeName | Should -BeLikeExactly "System.Net.IPSubnet"
        }

        It "IPAddressV6" {
            $Result = New-IPSubnet -IPAddress "fe80::" -IPPrefix 64 | Get-Member

            $Result.TypeName | Should -BeLikeExactly "System.Net.IPSubnet"
        }

        It "InputObject" {
            $Result = New-IPSubnet -InputObject "169.254.0.0/16", "fe80::/64" | Get-Member

            $Result.TypeName | Should -BeLikeExactly "System.Net.IPSubnet"
        }

        It "Pipeline" {
            $Result = "169.254.0.0/16", "fe80::/64" | New-IPSubnet | Get-Member

            $Result.TypeName | Should -BeLikeExactly "System.Net.IPSubnet"
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "FormatException" {
            $Test = { New-IPSubnet -IPAddress "ThrowError" -IPPrefix 16 -ErrorAction Stop }

            $Test | Should -Throw "An invalid IP address was specified."
        }

        It "InvalidCastV4" {
            $Test = { New-IPSubnet -IPAddress "169.254.0.0" -IPPrefix 33 -ErrorAction Stop }

            $Test | Should -Throw "An invalid prefix for the address family was specified."
        }

        It "InvalidCastV6" {
            $Test = { New-IPSubnet -IPAddress "fe80::" -IPPrefix 129 -ErrorAction Stop }

            $Test | Should -Throw "An invalid prefix for the address family was specified."
        }
    }
}

Describe "IPSubnet Class" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "Contains is True" {
            $Result = "169.254.0.0/16", "fe80::/64" | New-IPSubnet

            $Result[0].Contains("169.254.0.255") | Should -BeTrue
            $Result[1].Contains("fe80::ffff") | Should -BeTrue
        }

        It "Contains is False" {
            $Result = "169.254.0.0/16", "fe80::/64" | New-IPSubnet

            $Result[0].Contains("fe80::ffff") | Should -BeFalse
            $Result[1].Contains("169.254.0.255") | Should -BeFalse
        }

        It "Subnet" {
            $Result = "169.254.0.0/16", "fe80::/64" | New-IPSubnet

            ($Subnets0 = $Result[0].Split(24)) | Should -HaveCount 256
            $Subnets0[0].Contains($Result[0].NetworkAddress) | Should -BeTrue
            $Subnets0[-1].Contains($Result[0].LastAddress) | Should -BeTrue


            ($Subnets1 = $Result[1].Split(72)) | Should -HaveCount 256
            $Subnets1[0].Contains($Result[1].NetworkAddress) | Should -BeTrue
            $Subnets1[-1].Contains($Result[1].LastAddress) | Should -BeTrue
        }

        It "Supernet" {
            $Result = "169.254.0.0/16", "fe80::/64" | New-IPSubnet

            ($Result0 = $Result[0].Split(8)) | Should -HaveCount 1
            $Result0[0].Contains($Result[0].NetworkAddress) | Should -BeTrue
            $Result0[0].Contains($Result[0].LastAddress) | Should -BeTrue

            ($Result1 = $Result[1].Split(56)) | Should -HaveCount 1
            $Result1[0].Contains($Result[1].NetworkAddress) | Should -BeTrue
            $Result1[0].Contains($Result[1].LastAddress) | Should -BeTrue
        }

        It "ToString" {
            $Result = "169.254.0.0/16", "fe80::/64" | New-IPSubnet

            $Result[0].ToString() | Should -BeExactly "169.254.0.0/16"
            $Result[1].ToString() | Should -BeExactly "fe80::/64"
        }
    }
}
