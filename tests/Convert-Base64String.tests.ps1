Describe 'Convert-Base64String' {
    BeforeAll {
        [string] $HashTable = 'PE9ianMgVmVyc2lvbj0iMS4xLjAuMSIgeG1sbnM9Imh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vcG93ZXJzaGVsbC8yMDA0LzA0Ij48T2JqIFJlZklkPSIwIj48VE4gUmVmSWQ9IjAiPjxUPlN5c3RlbS5Db2xsZWN0aW9ucy5IYXNodGFibGU8L1Q+PFQ+U3lzdGVtLk9iamVjdDwvVD48L1ROPjxEQ1Q+PEVuPjxTIE49IktleSI+VGVzdDwvUz48QiBOPSJWYWx1ZSI+dHJ1ZTwvQj48L0VuPjwvRENUPjwvT2JqPjwvT2Jqcz4='
        [string] $Bytes = 'AID/'
        [string] $String = 'aGVsbG8gd29ybGQ='
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

            It 'Bytes' {
                $Result = ConvertTo-Base64String -InputObject @(0, 128, 255)

                $Result | Should -Be $Bytes
            }

            It 'String' {
                $Result = ConvertTo-Base64String -InputObject 'hello world'

                $Result | Should -Be $String
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

            It 'Bytes' {
                $Result = $Bytes | ConvertFrom-Base64String

                $Result | Should -Be @(0, 128, 255)
            }

            It 'String' {
                $Result = $String | ConvertFrom-Base64String -AsString

                $Result | Should -Be 'hello world'
            }
        }
    }
}
