Describe 'Convert-Base64String' {
    BeforeAll {
        $HashTable = 'PE9ianMgVmVyc2lvbj0iMS4xLjAuMSIgeG1sbnM9Imh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vcG93ZXJzaGVsbC8yMDA0LzA0Ij4KICA8T2JqIFJlZklkPSIwIj4KICAgIDxUTiBSZWZJZD0iMCI+CiAgICAgIDxUPlN5c3RlbS5Db2xsZWN0aW9ucy5IYXNodGFibGU8L1Q+CiAgICAgIDxUPlN5c3RlbS5PYmplY3Q8L1Q+CiAgICA8L1ROPgogICAgPERDVD4KICAgICAgPEVuPgogICAgICAgIDxTIE49IktleSI+VGVzdDwvUz4KICAgICAgICA8QiBOPSJWYWx1ZSI+dHJ1ZTwvQj4KICAgICAgPC9Fbj4KICAgIDwvRENUPgogIDwvT2JqPgo8L09ianM+'
    }

    Context 'ConvertTo-Base64String' {
        Context 'Success' {
            It 'Pipeline' {
                $Result = @{ Test = $true } | ConvertTo-Base64String

                $Result | Should -Be $HashTable
            }

            It 'InputObject' {
                $Result = ConvertTo-Base64String -InputObject @{ Test = $true }

                $Result | Should -Be $HashTable
            }
        }
    }

    Context 'ConvertFrom-Base64String' {
        Context 'Success' {
            It 'Pipeline' {
                $Result = $HashTable | ConvertFrom-Base64String

                $Result['Test'] | Should -Be $true
            }

            It 'InputObject' {
                $Result = ConvertFrom-Base64String -InputObject $HashTable

                $Result['Test'] | Should -Be $true
            }
        }

        Context 'Failure' {
            It 'FormatException' {
                $Test = { ConvertFrom-Base64String -InputObject 'ThrowError' -ErrorAction Stop }

                if ($PSVersionTable.PSVersion.Major -le 5) {
                    $Test | Should -Throw 'Invalid length for a Base-64 char array or string.'
                } else {
                    $Test | Should -Throw 'The input is not a valid Base-64 string*'
                }
            }
        }
    }
}
