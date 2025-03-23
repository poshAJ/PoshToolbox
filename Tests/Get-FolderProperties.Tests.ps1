BeforeAll {
    ## SOURCE #################################################################
    Import-Module "${PSScriptRoot}\..\PoshToolbox\PoshToolbox.psm1"

    ## SETUP ##################################################################
    Push-Location -Path "TestDrive:\"

    $null = New-Item -Path "TestDrive:\Folder1", "TestDrive:\Folder2" -ItemType Directory
    $null = Set-Content -Path "TestDrive:\5MB.file" -Value ([byte[]]::new(5MB)) -Encoding Byte

    $ComparatorKB = [pscustomobject] @{
        FullName = (Get-Location -PSProvider FileSystem).ProviderPath
        Length   = 5242880
        Size     = "5,242.88 KB"
        Contains = "1 Files, 2 Folders"
        Created  = "*"
    }

    $ComparatorMiB = [pscustomobject] @{
        FullName = (Get-Location -PSProvider FileSystem).ProviderPath
        Length   = 5242880
        Size     = "5.00 MiB"
        Contains = "1 Files, 2 Folders"
        Created  = "*"
    }
}

Describe "Get-FolderProperties" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "Path" {
            $Result = Get-FolderProperties -Path "."
            $Result | Should -BeLike $ComparatorMiB
        }

        It "LiteralPath" {
            $Result = Get-FolderProperties -LiteralPath "."
            $Result | Should -BeLike $ComparatorMiB
        }

        It "Path & Unit" {
            $Result = Get-FolderProperties -Path "." -Unit KB
            $Result | Should -BeLike $ComparatorKB
        }

        It "LiteralPath & Unit" {
            $Result = Get-FolderProperties -LiteralPath "." -Unit KB
            $Result | Should -BeLike $ComparatorKB
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "UnauthorizedAccessException" {
            $Test = { Get-FolderProperties -Path "C:\Config.Msi\" -ErrorAction Stop }
            $Test | Should -Throw "Access to the path 'C:\Config.Msi\' is denied."
        }
    }
}

AfterAll {
    ## CLEAN UP ###############################################################
    Pop-Location
}
