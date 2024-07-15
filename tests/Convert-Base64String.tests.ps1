Describe 'Convert-Base64String' {
    BeforeAll {
        $HashTable = 'PABPAGIAagBzACAAVgBlAHIAcwBpAG8AbgA9ACIAMQAuADEALgAwAC4AMQAiACAAeABtAGwAbgBzAD0AIgBoAHQAdABwADoALwAvAHMAYwBoAGUAbQBhAHMALgBtAGkAYwByAG8AcwBvAGYAdAAuAGMAbwBtAC8AcABvAHcAZQByAHMAaABlAGwAbAAvADIAMAAwADQALwAwADQAIgA+ADwATwBiAGoAIABSAGUAZgBJAGQAPQAiADAAIgA+ADwAVABOACAAUgBlAGYASQBkAD0AIgAwACIAPgA8AFQAPgBTAHkAcwB0AGUAbQAuAEMAbwBsAGwAZQBjAHQAaQBvAG4AcwAuAEgAYQBzAGgAdABhAGIAbABlADwALwBUAD4APABUAD4AUwB5AHMAdABlAG0ALgBPAGIAagBlAGMAdAA8AC8AVAA+ADwALwBUAE4APgA8AEQAQwBUAD4APABFAG4APgA8AFMAIABOAD0AIgBLAGUAeQAiAD4AVABlAHMAdAA8AC8AUwA+ADwAQgAgAE4APQAiAFYAYQBsAHUAZQAiAD4AdAByAHUAZQA8AC8AQgA+ADwALwBFAG4APgA8AC8ARABDAFQAPgA8AC8ATwBiAGoAPgA8AC8ATwBiAGoAcwA+AA=='
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
    }
}
