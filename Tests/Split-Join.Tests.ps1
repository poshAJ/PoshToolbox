BeforeAll {
    ## SOURCE #################################################################
    Import-Module "${PSScriptRoot}\..\PoshToolbox\PoshToolbox.psm1"

    ## SETUP ##################################################################
    $TestFolder = New-Item -Path "${env:TMP}\$( [guid]::NewGuid() )" -ItemType Directory
    Push-Location -Path $TestFolder

    $Random = [System.Random]::new()
    $Buffer = [byte[]]::new(5MB)

    $Random.NextBytes($Buffer)

    $File = Set-Content -Path "5MB.file" -Value $Buffer -Encoding Byte -PassThru
    $FileHash = Get-FileHash -Path "5MB.file"
}

Describe "Split-File" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Result = Split-File -Path "*.file" -Size 1MB

            $Result.Count | Should -Be 5
            $Result.Name | Should -BeLike "5MB.file.*split"
        }

        It "LiteralPath" {
            $Result = Split-File -LiteralPath "5MB.file" -Size 1MB

            $Result.Count | Should -Be 5
            $Result.Name | Should -BeLike "5MB.file.*split"
        }

        It "Path & Destination" {
            $Result = Split-File -Path "*.file" -Size 1MB -Destination "Copy\"

            $Result.Count | Should -Be 5
            $Result.Name | Should -BeLike "5MB.file.*split"
        }

        It "LiteralPath & Destination" {
            $Result = Split-File -LiteralPath "5MB.file" -Size 1MB -Destination "Copy\"

            $Result.Count | Should -Be 5
            $Result.Name | Should -BeLike "5MB.file.*split"
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "DirectoryNotFoundException" {
            $Test = { Split-File -Path "5MB.file" -Size 1MB -Destination "\\Throw\Error" -ErrorAction Stop }

            $Test | Should -Throw "Could not find a part of the path '\\Throw\Error'."
        }

        It "UnauthorizedAccessException" {
            $Test = { Split-File -Path "5MB.file" -Size 1MB -Destination "C:\Config.Msi\" -ErrorAction Stop }

            $Test | Should -Throw "Access to the path 'C:\Config.Msi\5MB.file.1split' is denied."
        }
    }
}

Describe "Join-File" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Result = Get-FileHash (Join-File -Path "*.file.1split")

            $Result.Hash | Should -Be $FileHash.Hash
            $Result.Path | Should -BeLike "*\5MB.file"
        }

        It "LiteralPath" {
            $Result = Get-FileHash (Join-File -LiteralPath "5MB.file.1split")

            $Result.Hash | Should -Be $FileHash.Hash
            $Result.Path | Should -BeLike "*\5MB.file"
        }

        It "Path & Destination" {
            $Result = Get-FileHash (Join-File -Path "*.file.1split" -Destination "5MB.copy")

            $Result.Hash | Should -Be $FileHash.Hash
            $Result.Path | Should -BeLike "*\5MB.copy"
        }

        It "LiteralPath & Destination" {
            $Result = Get-FileHash (Join-File -LiteralPath "5MB.file.1split" -Destination "5MB.copy")

            $Result.Hash | Should -Be $FileHash.Hash
            $Result.Path | Should -BeLike "*\5MB.copy"
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "DirectoryNotFoundException" {
            $Test = { Join-File -Path "5MB.file.1split" -Destination "\\Throw\Error" -ErrorAction Stop }

            $Test | Should -Throw "Could not find a part of the path '\\Throw\Error'."
        }

        It "UnauthorizedAccessException" {
            $Test = { Join-File -Path "5MB.file.1split" -Destination "C:\Config.Msi\" -ErrorAction Stop }

            $Test | Should -Throw "Access to the path 'C:\Config.Msi\5MB.file' is denied."
        }
    }
}

AfterAll {
    ## CLEAN UP ###############################################################
    Pop-Location
    Remove-Item -Path $TestFolder -Recurse -Force
}
