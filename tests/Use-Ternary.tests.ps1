Describe 'Use-Ternary' {
    Context 'Success' {
        It 'True' {
            $Result = $true | Use-Ternary 'VALUE' $false

            $Result | Should -Be 'VALUE'
        }

        It 'True ScriptBlock' {
            $Result = $true | Use-Ternary { 'VALUE' } { $false }

            $Result | Should -Be 'VALUE'
        }

        It 'False' {
            $Result = $false | Use-Ternary $true 'VALUE'

            $Result | Should -Be 'VALUE'
        }

        It 'False ScriptBlock' {
            $Result = $false | Use-Ternary { $true } { 'VALUE' }

            $Result | Should -Be 'VALUE'
        }
    }
}
