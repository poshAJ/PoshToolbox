# Copyright (c) 2022 Anthony J. Raymond, MIT License (see manifest for details)

using namespace System.Runtime.InteropServices

function Use-Object {
    [CmdletBinding()]
    [OutputType([void])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            Mandatory
        )]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [AllowNull()]
        [object]
        $InputObject,

        [Parameter(
            Position = 1,
            Mandatory
        )]
        [scriptblock]
        $Scriptblock
    )

    ## PROCESS ################################################################
    process {
        try {
            . $Scriptblock
        } catch {
            throw $_
        } finally {
            foreach ($Object in $InputObject) {
                if ($Object -is [IDisposable]) {
                    $Object.Dispose()
                } elseif ($Object -is [__ComObject]) {
                    $null = [Marshal]::ReleaseComObject($Object)
                }
            }
        }
    }
}


Set-Alias -Name using -Value Use-Object
