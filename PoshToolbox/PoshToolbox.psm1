# Copyright (c) 2022 Anthony J. Raymond, MIT License (see manifest for details)
# Copyright (c) 2015 Warren Frame, Modified "PowerShell Module Framework" (http://github.com/ramblingcookiemonster)

$Classes = Get-ChildItem -Path "${PSScriptRoot}\Classes\*.ps1" -ErrorAction SilentlyContinue

foreach ($Class in $Classes) {
    try {
        . $Class.FullName
    } catch {
        throw ([System.Management.Automation.ErrorRecord]::new(
                [System.IO.FileLoadException] ("The class '{0}' was not loaded because an error occurred." -f $Class.BaseName),
                "ClassUnavailable",
                [System.Management.Automation.ErrorCategory]::ResourceUnavailable,
                $Class.FullName
            ))
    }
}

$Exceptions = Get-ChildItem -Path "${PSScriptRoot}\Exceptions\*.ps1" -ErrorAction SilentlyContinue

foreach ($Exception in $Exceptions) {
    try {
        . $Exception.FullName
    } catch {
        throw ([System.Management.Automation.ErrorRecord]::new(
                [System.IO.FileLoadException] ("The exception '{0}' was not loaded because an error occurred." -f $Exception.BaseName),
                "ExceptionUnavailable",
                [System.Management.Automation.ErrorCategory]::ResourceUnavailable,
                $Exception.FullName
            ))
    }
}

$Public = Get-ChildItem -Path "${PSScriptRoot}\Public\*.ps1" -ErrorAction SilentlyContinue

foreach ($Function in $Public) {
    try {
        . $Function.FullName
    } catch {
        throw ([System.Management.Automation.ErrorRecord]::new(
                [System.IO.FileLoadException] ("The function '{0}' was not loaded because an error occurred." -f $Function.BaseName),
                "FunctionUnavailable",
                [System.Management.Automation.ErrorCategory]::ResourceUnavailable,
                $Function.FullName
            ))
    }
}

Export-ModuleMember -Function $Public.BaseName
