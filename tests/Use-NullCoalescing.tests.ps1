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
    }
}
