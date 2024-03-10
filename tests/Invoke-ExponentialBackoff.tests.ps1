Describe "Invoke-ExponentialBackoff" {
    ## SUCCESS ################################################################
    Context "Success" {
        BeforeEach {
            $Error.Clear()
        }

        It "1 Retry" {
            $Result = Invoke-ExponentialBackoff -ErrorAction SilentlyContinue -ScriptBlock {
                if ($Error.Count -lt 1) { throw }
                $Error.Count
            }

            $Result | Should -Be 1
        }

        It "2 Retry" {
            $Result = Invoke-ExponentialBackoff -ErrorAction SilentlyContinue -ScriptBlock {
                if ($Error.Count -lt 2) { throw }
                $Error.Count
            }

            $Result | Should -Be 2
        }
    }

    ## FAILURE ################################################################
    Context "Failure" {
        BeforeEach {
            $Error.Clear()
        }

        It "Timeout" {
            $Test = { Invoke-ExponentialBackoff -ErrorAction SilentlyContinue -ScriptBlock { throw } }

            $Test | Should -Throw "The operation has reached the limit of 3 retries."
            $Error.Count | Should -Be 4
        }
    }
}
