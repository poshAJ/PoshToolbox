Describe 'Use-Object' {
    Context 'Success' {
        It 'IDisposable' {
            $Test = {
                Use-Object ($Disposable = [System.IO.File]::OpenRead($PSCommandPath)) {}
                $Disposable.ReadByte()
            }

            if ($PSVersionTable.PSVersion.Major -le 5) {
                $Test | Should -Throw '*"Cannot access a closed file."'
            } else {
                $Test | Should -Throw '*"Cannot access a closed Stream."'
            }
        }

        It 'ComObject' -Skip:($env:OS -ne 'Windows_NT') {
            $Test = {
                Use-Object ($ComObject = New-Object -ComObject WScript.Shell) {}
                $ComObject
            }

            $Test | Should -Throw 'COM object that has been separated from its underlying RCW cannot be used.'
        }
    }
}
