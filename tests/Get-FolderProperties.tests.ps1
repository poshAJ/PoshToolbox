Describe 'Get-FolderProperties' -Skip:($env:OS -ne 'Windows_NT') {
    BeforeAll {
        Push-Location -Path 'TestDrive:/'

        $null = New-Item -Path 'TestDrive:/Folder1', 'TestDrive:/Folder2' -ItemType Directory

        if ($PSVersionTable.PSVersion.Major -le 5) {
            $null = Set-Content -Path 'TestDrive:/5MB.file' -Value ([byte[]]::new(5MB)) -Encoding Byte
        } else {
            $null = Set-Content -Path 'TestDrive:/5MB.file' -Value ([byte[]]::new(5MB)) -AsByteStream
        }

        $KnownKB = [pscustomobject] @{
            FullName = (Get-Location -PSProvider FileSystem).ProviderPath
            Length   = 5242880
            Size     = '5,242.88 KB'
            Contains = '1 Files, 2 Folders'
            Created  = '*'
        }

        $KnownMiB = [pscustomobject] @{
            FullName = (Get-Location -PSProvider FileSystem).ProviderPath
            Length   = 5242880
            Size     = '5.00 MiB'
            Contains = '1 Files, 2 Folders'
            Created  = '*'
        }
    }

    Context 'Success' {
        It 'Path' {
            $Result = Get-FolderProperties -Path '.'

            $Result | Should -BeLike $KnownMiB
        }

        It 'LiteralPath' {
            $Result = Get-FolderProperties -LiteralPath '.'

            $Result | Should -BeLike $KnownMiB
        }

        It 'Path & Unit' {
            $Result = Get-FolderProperties -Path '.' -Unit KB

            $Result | Should -BeLike $KnownKB
        }

        It 'LiteralPath & Unit' {
            $Result = Get-FolderProperties -LiteralPath '.' -Unit KB

            $Result | Should -BeLike $KnownKB
        }
    }

    AfterAll { Pop-Location }
}
