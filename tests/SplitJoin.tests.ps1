Describe 'SplitJoin' {
    BeforeAll {
        $TestFolder = New-Item -Path "$( [System.IO.Path]::GetTempPath() )$( [guid]::NewGuid() )" -ItemType Directory
        Push-Location -Path $TestFolder

        $Random = [System.Random]::new()
        $Buffer = [byte[]]::new(5MB)

        $Random.NextBytes($Buffer)

        if ($PSVersionTable.PSVersion.Major -le 5) {
            $File = Set-Content -Path '5MB.file' -Value $Buffer -Encoding Byte -PassThru
        } else {
            $File = Set-Content -Path '5MB.file' -Value $Buffer -AsByteStream -PassThru
        }

        $FileHash = Get-FileHash -Path '5MB.file'
    }

    Context 'Split-File' {
        Context 'Success' {
            It 'Path' {
                $Result = Split-File -Path '*.file' -Size 1MB

                $Result.Count | Should -Be 5
                $Result.Name | Should -BeLike '5MB.file.*split'
            }

            It 'LiteralPath' {
                $Result = Split-File -LiteralPath '5MB.file' -Size 1MB

                $Result.Count | Should -Be 5
                $Result.Name | Should -BeLike '5MB.file.*split'
            }

            It 'Path & Destination' {
                $Result = Split-File -Path '*.file' -Size 1MB -Destination 'Copy/'

                $Result.Count | Should -Be 5
                $Result.Name | Should -BeLike '5MB.file.*split'
            }

            It 'LiteralPath & Destination' {
                $Result = Split-File -LiteralPath '5MB.file' -Size 1MB -Destination 'Copy/'

                $Result.Count | Should -Be 5
                $Result.Name | Should -BeLike '5MB.file.*split'
            }
        }
    }

    Context 'Join-File' {
        Context 'Success' {
            It 'Path' {
                $Result = Get-FileHash (Join-File -Path '*.file.1split')

                $Result.Hash | Should -Be $FileHash.Hash
                $Result.Path | Should -BeLike '*5MB.file'
            }

            It 'LiteralPath' {
                $Result = Get-FileHash (Join-File -LiteralPath '5MB.file.1split')

                $Result.Hash | Should -Be $FileHash.Hash
                $Result.Path | Should -BeLike '*5MB.file'
            }

            It 'Path & Destination' {
                $Result = Get-FileHash (Join-File -Path '*.file.1split' -Destination '5MB.copy')

                $Result.Hash | Should -Be $FileHash.Hash
                $Result.Path | Should -BeLike '*5MB.copy'
            }

            It 'LiteralPath & Destination' {
                $Result = Get-FileHash (Join-File -LiteralPath '5MB.file.1split' -Destination '5MB.copy')

                $Result.Hash | Should -Be $FileHash.Hash
                $Result.Path | Should -BeLike '*5MB.copy'
            }
        }
    }

    AfterAll {
        Pop-Location
        Remove-Item -Path $TestFolder -Recurse -Force
    }
}
