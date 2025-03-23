Describe "Get-FolderProperties" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "${PSScriptRoot}\..\PoshToolbox.psm1"

        ## SETUP ##############################################################
        Push-Location -Path "${PSScriptRoot}\Files"

        $ComparatorKB = [pscustomobject] @{
            FullName = (Get-Location -PSProvider FileSystem).ProviderPath
            Length   = 52428800
            Size     = "52,428.80 KB"
            Contains = "6 Files, 0 Folders"
            Created  = "*"
        }

        $ComparatorMiB = [pscustomobject] @{
            FullName = (Get-Location -PSProvider FileSystem).ProviderPath
            Length   = 52428800
            Size     = "50.00 MiB"
            Contains = "6 Files, 0 Folders"
            Created  = "*"
        }
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Test = Get-FolderProperties -Path "."
            $Test | Should -BeLike $ComparatorMiB
        }

        It "LiteralPath" {
            $Test = Get-FolderProperties -LiteralPath "."
            $Test | Should -BeLike $ComparatorMiB
        }

        It "Path & Unit" {
            $Test = Get-FolderProperties -Path "." -Unit KB
            $Test | Should -BeLike $ComparatorKB
        }

        It "LiteralPath & Unit" {
            $Test = Get-FolderProperties -LiteralPath "." -Unit KB
            $Test | Should -BeLike $ComparatorKB
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "UnauthorizedAccessException" {
            $Test = { Get-FolderProperties -Path "C:\Config.Msi\" -ErrorAction Stop }
            $Test | Should -Throw "Access to the path 'C:\Config.Msi\' is denied."
        }
    }

    AfterAll {
        ## CLEAN UP ###########################################################
        Pop-Location
    }
}
