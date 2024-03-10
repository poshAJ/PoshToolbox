Describe "ConvertFrom-Base64String" {
    BeforeAll {
        ## SOURCE #############################################################
        Import-Module "${PSScriptRoot}\..\PoshToolbox.psm1"

        ## SETUP ##############################################################
        Push-Location -Path "${PSScriptRoot}\Files"

        $Bytes = Get-Content -Path "5MB.file.1split" -Encoding Byte
        $String = [Convert]::ToBase64String($Bytes)

        # byte array comparison in pester is stupidly slow, compare the hash instead
        $Hash = (Get-FileHash -Path "5MB.file.1split").Hash
        function Get-ByteHash ([byte[]] $Byte) {
            $Provider = [System.Security.Cryptography.SHA256CryptoServiceProvider]::new()
            return -join $Provider.ComputeHash($Byte).ForEach({ $_.ToString("x2").ToUpper() })
        }
    }

    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Test = ConvertFrom-Base64String -Path "*.1split.txt"
            (Get-FileHash $Test).Hash | Should -Be $Hash
        }

        It "LiteralPath" {
            $Test = ConvertFrom-Base64String -LiteralPath "5MB.file.1split.txt"
            (Get-FileHash $Test).Hash | Should -Be $Hash
        }

        It "InputObject & Destination" {
            $Test = ConvertFrom-Base64String -InputObject $String -Destination "Copy.file"
            $Test.Name | Should -Be "Copy.file"
            (Get-FileHash $Test).Hash | Should -Be $Hash
        }

        It "Path & Destination" {
            $Test = ConvertFrom-Base64String -Path "*.1split.txt" -Destination "Copy.file"
            $Test.Name | Should -Be "Copy.file"
            (Get-FileHash $Test).Hash | Should -Be $Hash
        }

        It "LiteralPath & Destination" {
            $Test = ConvertFrom-Base64String -LiteralPath "5MB.file.1split.txt" -Destination "Copy.file"
            $Test.Name | Should -Be "Copy.file"
            (Get-FileHash $Test).Hash | Should -Be $Hash
        }

        It "InputObject & AsByte" {
            $Test = ConvertFrom-Base64String -InputObject $String -AsBytes
            Get-ByteHash $Test | Should -Be $Hash
        }

        It "Path & AsByte" {
            $Test = ConvertFrom-Base64String -Path "*.1split.txt" -AsBytes
            Get-ByteHash $Test | Should -Be $Hash
        }

        It "LiteralPath & AsByte" {
            $Test = ConvertFrom-Base64String -LiteralPath "5MB.file.1split.txt" -AsBytes
            Get-ByteHash $Test | Should -Be $Hash
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "DirectoryNotFoundException" {
            $Test = { ConvertFrom-Base64String -Path "5MB.file.1split.txt" -Destination "\\fake\potato" -ErrorAction Stop }
            $Test | Should -Throw "Could not find a part of the path '\\fake\potato'."
        }

        It "UnauthorizedAccessException" {
            $Test = { ConvertFrom-Base64String -InputObject "AA==" -Destination "C:\Config.Msi\potato.file" -ErrorAction Stop }
            $Test | Should -Throw "Access to the path 'C:\Config.Msi\potato.file' is denied."
        }

        It "FormatException" {
            $Test = { ConvertFrom-Base64String -InputObject "potato" -Destination "potato.file" -ErrorAction Stop }
            $Test | Should -Throw "Invalid length for a Base-64 char array or string."
        }
    }

    AfterAll {
        ## CLEAN UP ###########################################################
        Remove-Item -Path "Copy.file"
        Pop-Location
    }
}
