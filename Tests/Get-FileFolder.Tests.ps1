Describe "Get-FileFolder" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "$PSScriptRoot\..\PoshToolbox.psm1"

        ## SETUP ##############################################################
        Push-Location -Path "$PSScriptRoot\..\docs"

        $ComparatorKB = [pscustomobject] @{
            FullName = (Get-Location -PSProvider FileSystem).ProviderPath
            Length   = 23107
            Size     = "23.11 KB"
            Contains = "10 Files, 0 Folders"
            Created  = "Thursday, March 30, 2023 7:13:49 AM"
        }

        $ComparatorMiB = [pscustomobject] @{
            FullName = (Get-Location -PSProvider FileSystem).ProviderPath
            Length   = 23107
            Size     = "0.02 MiB"
            Contains = "10 Files, 0 Folders"
            Created  = "Thursday, March 30, 2023 7:13:49 AM"
        }
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Test = Get-FileFolder -Path "."
            $Test | Should -BeLike $ComparatorMiB
        }

        It "LiteralPath" {
            $Test = Get-FileFolder -LiteralPath "."
            $Test | Should -BeLike $ComparatorMiB
        }

        It "Path & Unit" {
            $Test = Get-FileFolder -Path "." -Unit KB
            $Test | Should -BeLike $ComparatorKB
        }

        It "LiteralPath & Unit" {
            $Test = Get-FileFolder -LiteralPath "." -Unit KB
            $Test | Should -BeLike $ComparatorKB
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "UnauthorizedAccessException" {
            $Test = { Get-FileFolder -Path "C:\Config.Msi\" -ErrorAction Stop }
            $Test | Should -Throw "Access to the path 'C:\Config.Msi\' is denied."
        }
    }

    AfterAll {
        ## CLEAN UP ###########################################################
        Pop-Location
    }
}
