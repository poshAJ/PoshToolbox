BeforeAll {
    ## SOURCE #################################################################
    Import-Module "${PSScriptRoot}\..\PoshToolbox\PoshToolbox.psm1"
}

Describe "Use-Ternary" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "True" {
            $Result = $true | Use-Ternary { "VALUE" } { 1 / 0 }
            $Result | Should -Be "VALUE"
        }

        It "False" {
            $Result = $false | Use-Ternary { 1 / 0 } { "VALUE" }
            $Result | Should -Be "VALUE"
        }
    }
}
