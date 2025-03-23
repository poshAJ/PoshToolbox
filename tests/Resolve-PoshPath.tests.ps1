BeforeAll {
    ## SETUP ##################################################################
    Push-Location "${PSScriptRoot}"

    $Path = Get-Item "*"
    $LiteralPath = Get-Item -LiteralPath "."
}

Describe "Resolve-PoshPath" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Result = Resolve-PoshPath -Path "*"

            $Result.ProviderPath | Should -Be $Path.FullName
        }

        It "LiteralPath" {
            $Result = Resolve-PoshPath -LiteralPath "."

            $Result.ProviderPath | Should -Be $LiteralPath.FullName
        }
    }
}

AfterAll {
    ## CLEAN UP ###############################################################
    Pop-Location
}
