Describe "Resolve-PoshPath" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "${PSScriptRoot}\..\PoshToolbox.psm1"

        ## SETUP ##############################################################
        Push-Location "${PSScriptRoot}"

        $Path = Get-Item "*"
        $LiteralPath = Get-Item -LiteralPath "."
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Test = Resolve-PoshPath -Path "*"
            $Test.ProviderPath | Should -Be $Path.FullName
        }

        It "LiteralPath" {
            $Test = Resolve-PoshPath -LiteralPath "."
            $Test.ProviderPath | Should -Be $LiteralPath.FullName
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "PathNotFound" {
            $Test = { Resolve-PoshPath "\\ThrowError" -ErrorAction Stop }
            $Test | Should -Throw "Cannot find path '*' because it does not exist."
        }
    }

    AfterAll {
        ## CLEAN UP ###########################################################
        Pop-Location
    }
}
