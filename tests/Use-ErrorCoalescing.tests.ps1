Describe 'Use-ErrorCoalescing' {
    Context 'Success' {
        It 'Error' {
            $Result = { throw } | Use-ErrorCoalescing 'VALUE'

            $Result | Should -Be 'VALUE'
        }

        It 'Error ScriptBlock' {
            $Result = { throw } | Use-ErrorCoalescing { 'VALUE' }

            $Result | Should -Be 'VALUE'
        }

        It 'Error Hashtable' {
            $Result = { throw } | Use-ErrorCoalescing @{ [System.Exception] = 'VALUE' }

            $Result | Should -Be 'VALUE'
        }

        It 'Error Hashtable ScriptBlock' {
            $Result = { throw } | Use-ErrorCoalescing @{ [System.Exception] = { 'VALUE' } }

            $Result | Should -Be 'VALUE'
        }

        It 'Not Error' {
            $Result = { 'VALUE' } | Use-ErrorCoalescing { throw }

            $Result | Should -Be 'VALUE'
        }
    }
}
