Describe "ConvertTo-Base64String" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "${PSScriptRoot}\..\PoshToolbox.psm1"

        ## SETUP ##############################################################
        Push-Location -Path "${PSScriptRoot}\Files"

        $Bytes = Get-Content -Path "5MB.file.1split" -Encoding Byte
        $String = [Convert]::ToBase64String($Bytes)
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Test = ConvertTo-Base64String -Path "*.1split"
            Get-Content $Test | Should -Be $String
        }

        It "LiteralPath" {
            $Test = ConvertTo-Base64String -LiteralPath "5MB.file.1split"
            Get-Content $Test | Should -Be $String
        }

        It "InputObject & Destination" {
            $Test = ConvertTo-Base64String -InputObject $Bytes -Destination "Copy.txt"
            $Test.Name | Should -Be "Copy.txt"
            Get-Content $Test | Should -Be $String
        }

        It "Path & Destination" {
            $Test = ConvertTo-Base64String -Path "*.1split" -Destination "Copy.txt"
            $Test.Name | Should -Be "Copy.txt"
            Get-Content $Test | Should -Be $String
        }

        It "LiteralPath & Destination" {
            $Test = ConvertTo-Base64String -LiteralPath "5MB.file.1split" -Destination "Copy.txt"
            $Test.Name | Should -Be "Copy.txt"
            Get-Content $Test | Should -Be $String
        }

        It "InputObject & AsString" {
            $Test = ConvertTo-Base64String -InputObject $Bytes -AsString
            $Test | Should -Be $String
        }

        It "Path & AsString" {
            $Test = ConvertTo-Base64String -Path "*.1split" -AsString
            $Test | Should -Be $String
        }

        It "LiteralPath & AsString" {
            $Test = ConvertTo-Base64String -LiteralPath "5MB.file.1split" -AsString
            $Test | Should -Be $String
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "DirectoryNotFoundException" {
            $Test = { ConvertTo-Base64String -Path "5MB.file.1split" -Destination "\\fake\potato" -ErrorAction Stop }
            $Test | Should -Throw "Could not find a part of the path '\\fake\potato'."
        }

        It "UnauthorizedAccessException" {
            $Test = { ConvertTo-Base64String -InputObject 0 -Destination "C:\Config.Msi\potato.txt" -ErrorAction Stop }
            $Test | Should -Throw "Access to the path 'C:\Config.Msi\potato.txt' is denied."
        }
    }

    AfterAll {
        ## CLEAN UP ###########################################################
        Remove-Item -Path "Copy.txt"
        Pop-Location
    }
}
