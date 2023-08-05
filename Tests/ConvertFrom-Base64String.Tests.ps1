BeforeAll {
    ## SOURCE #################################################################
    Import-Module "${PSScriptRoot}\..\PoshToolbox\PoshToolbox.psm1"

    ## SETUP ##################################################################
    $HashTable = "PE9ianMgVmVyc2lvbj0iMS4xLjAuMSIgeG1sbnM9Imh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vcG93ZXJzaGVsbC8yMDA0LzA0Ij4NCiAgPE9iaiBSZWZJZD0iMCI+DQogICAgPFROIFJlZklkPSIwIj4NCiAgICAgIDxUPlN5c3RlbS5Db2xsZWN0aW9ucy5IYXNodGFibGU8L1Q+DQogICAgICA8VD5TeXN0ZW0uT2JqZWN0PC9UPg0KICAgIDwvVE4+DQogICAgPERDVD4NCiAgICAgIDxFbj4NCiAgICAgICAgPFMgTj0iS2V5Ij5UZXN0PC9TPg0KICAgICAgICA8QiBOPSJWYWx1ZSI+dHJ1ZTwvQj4NCiAgICAgIDwvRW4+DQogICAgPC9EQ1Q+DQogIDwvT2JqPg0KPC9PYmpzPg=="
}

Describe "ConvertFrom-Base64String" {
    ## SUCCESS ################################################################
    Context "Success" {
        It "Pipeline" {
            $Result = $HashTable | ConvertFrom-Base64String

            $Result["Test"] | Should -Be $true
        }

        It "InputObject" {
            $Result = ConvertFrom-Base64String -InputObject $HashTable

            $Result["Test"] | Should -Be $true
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        It "FormatException" {
            $Test = { ConvertFrom-Base64String -InputObject "ThrowError" -ErrorAction Stop }

            $Test | Should -Throw "Invalid length for a Base-64 char array or string."
        }
    }
}
