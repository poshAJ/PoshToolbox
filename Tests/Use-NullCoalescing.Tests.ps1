Describe "Use-NullCoalescing" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "${PSScriptRoot}\..\PoshToolbox.psm1"

        ## SETUP ##############################################################
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "Null" {
            $Test = $null | ?? { "VALUE" }
            $Test | Should -Be "VALUE"
        }

        It "Not Null" {
            $Test = "VALUE" | ?? { 1 / 0 }
            $Test | Should -Be "VALUE"
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
    }

    AfterAll {
        ## CLEAN UP ###########################################################
    }
}
