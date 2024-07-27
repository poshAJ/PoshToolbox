Describe 'Get-FolderProperties' -Skip:($env:OS -ne 'Windows_NT') {
    BeforeAll {
        Push-Location -Path 'TestDrive:/'

        $TestFolders = New-Item -Path 'TestDrive:/Folder1', 'TestDrive:/Folder2' -ItemType 'Directory'

        if ($PSVersionTable.PSVersion.Major -le 5) {
            $null = Set-Content -Path 'TestDrive:/5MB.file' -Value ([byte[]]::new(5MB)) -Encoding 'Byte'
        } else {
            $null = Set-Content -Path 'TestDrive:/5MB.file' -Value ([byte[]]::new(5MB)) -AsByteStream
        }

        $KnownKB = [PoshToolbox.GetFolderPropertiesCommand+FolderPropertiesInfo]::new(
            (Get-Location -PSProvider 'FileSystem').ProviderPath,
            5242880,
            '5,242.88 KB',
            '1 Files, 2 Folders',
            $TestFolders[0].CreationTime
        )

        $KnownMiB = [PoshToolbox.GetFolderPropertiesCommand+FolderPropertiesInfo]::new(
            (Get-Location -PSProvider 'FileSystem').ProviderPath,
            5242880,
            '5.00 MiB',
            '1 Files, 2 Folders',
            $TestFolders[0].CreationTime
        )
    }

    Context 'Success' {
        It 'Type' {
            $Result = Get-FolderProperties -Path '.'

            $Result | Should -BeOfType [PoshToolbox.GetFolderPropertiesCommand+FolderPropertiesInfo]
        }

        It 'Path' {
            $Result = Get-FolderProperties -Path '.' -Unit 'MiB'

            $Result | Should -BeLike $KnownMiB
        }

        It 'LiteralPath' {
            $Result = Get-FolderProperties -LiteralPath '.' -Unit 'MiB'

            $Result | Should -BeLike $KnownMiB
        }

        It 'Path & Unit' {
            $Result = Get-FolderProperties -Path '.' -Unit 'KB'

            $Result | Should -BeLike $KnownKB
        }

        It 'LiteralPath & Unit' {
            $Result = Get-FolderProperties -LiteralPath '.' -Unit 'KB'

            $Result | Should -BeLike $KnownKB
        }
    }

    AfterAll { Pop-Location }
}
