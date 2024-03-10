Describe "Resolve-PoshPath" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "$PSScriptRoot\..\PoshToolbox.psm1"

        ## SETUP ##############################################################
        Push-Location "$PSScriptRoot"

        $Path = Get-Item "*"
        $LiteralPath = Get-Item -LiteralPath "."
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Test = Resolve-PoshPath "*"
            $Test | Should -Be $Path.FullName
        }

        It "LiteralPath" {
            $Test = Resolve-PoshPath -LiteralPath "."
            $Test | Should -Be $LiteralPath.FullName
        }

        It "Path & Provider" {
            $Test = Resolve-PoshPath "*" -Provider
            $Test | Should -Be $Path.PSProvider[0]
        }

        It "LiteralPath & Provider" {
            $Test = Resolve-PoshPath -LiteralPath "." -Provider
            $Test | Should -Be $LiteralPath.PSProvider
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
