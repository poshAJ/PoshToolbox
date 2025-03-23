@{

    RootModule        = "PoshToolbox.psm1"

    ModuleVersion     = "2.0.0"

    # CompatiblePSEditions = @()

    GUID              = "c91f141d-3103-49f0-8813-88a68479ae3e"

    Author            = "Anthony J. Raymond"

    # CompanyName = ""

    Copyright         = "(c) 2022 Anthony J. Raymond"

    Description       = "A collection of functions that can be used to build PowerShell scripts and modules."

    # PowerShellVersion = ""

    # PowerShellHostName = ""

    # PowerShellHostVersion = ""

    # DotNetFrameworkVersion = ""

    # CLRVersion = ""

    # ProcessorArchitecture = ""

    # RequiredModules = @()

    # RequiredAssemblies = @()

    # ScriptsToProcess = @()

    # TypesToProcess = @()

    # FormatsToProcess = @()

    # NestedModules = @()

    FunctionsToExport = @(
        "Resolve-PoshPath"
        "Start-PoshLog"
        "Write-PoshLog"
        "Stop-PoshLog"
        "Use-NullCoalescing"
        "Use-Object"
        "Use-Ternary"
        "Get-ADServiceAccountCredential"
    )

    CmdletsToExport   = @()

    VariablesToExport = ""

    AliasesToExport   = @(
        "using"
        "?:"
        "??"
    )

    # DscResourcesToExport = @()

    # ModuleList = @()

    # FileList = @()

    PrivateData       = @{

        PSData = @{

            Tags         = @(
                "script"
                "module"
                "framework"
                "toolbox"
                "logging"
            )

            LicenseUri   = "https://github.com/PoshAJ/PoshToolbox/blob/main/LICENSE"

            ProjectUri   = "https://github.com/PoshAJ/PoshToolbox"

            # IconUri = ""

            ReleaseNotes = ""

        }

    }

    HelpInfoURI       = "https://github.com/PoshAJ/PoshToolbox/blob/main/README.md"

    # DefaultCommandPrefix = ""

}
