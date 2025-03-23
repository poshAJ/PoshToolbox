Describe "New-IPAddress" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "IPAddress" {
            $Result = New-IPAddress -IPAddress "169.254.0.0", "fe80::" | Get-Member

            $Result.TypeName | Should -BeLikeExactly "System.Net.IPAddress"
        }

        It "Pipeline" {
            $Result = "169.254.0.0", "fe80::" | New-IPAddress | Get-Member

            $Result.TypeName | Should -BeLikeExactly "System.Net.IPAddress"
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "FormatException" {
            $Test = { New-IPAddress -IPAddress "ThrowError" -ErrorAction Stop }

            $Test | Should -Throw "An invalid IP address was specified."
        }
    }
}
