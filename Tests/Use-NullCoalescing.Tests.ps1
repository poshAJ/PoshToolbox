BeforeAll {
    ## SOURCE #################################################################
    Import-Module "${PSScriptRoot}\..\PoshToolbox\PoshToolbox.psm1"
}

Describe "Use-NullCoalescing" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "Null" {
            $Result = $null | Use-NullCoalescing { "VALUE" }
            $Result | Should -Be "VALUE"
        }

        It "Not Null" {
            $Result = "VALUE" | Use-NullCoalescing { 1 / 0 }
            $Result | Should -Be "VALUE"
        }
    }
}
