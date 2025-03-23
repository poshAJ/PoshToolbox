Describe "Use-NullCoalescing" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "Null" {
            $Result = $null | Use-NullCoalescing "VALUE"

            $Result | Should -Be "VALUE"
        }

        It "Null ScriptBlock" {
            $Result = $null | Use-NullCoalescing { "VALUE" }

            $Result | Should -Be "VALUE"
        }

        It "Not Null" {
            $Result = "VALUE" | Use-NullCoalescing { $null }

            $Result | Should -Be "VALUE"
        }

        It "Empty Pipeline" {
            $Result = Where-Object $false | Use-NullCoalescing "VALUE"

            $Result | Should -be "VALUE"
        }

        It "Mixed Pipeline" {
            $Result = $null, "VALUE2" | Use-NullCoalescing "VALUE1"

            $Result | Should -Be "VALUE1", "VALUE2"
        }

        It "Hashtable Regression" {
            $Result = @{ KEY = "VALUE" } | Use-NullCoalescing { $null }

            $Result | Should -BeOfType [hashtable] -Because "#30"
        }
    }
}
