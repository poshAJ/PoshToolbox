$Script:RootModule = "PoshToolbox"
$Script:RequiredModules = "PlatyPS", "Pester", "PSScriptAnalyzer"


task CleanModules {
    foreach ($Module in $RequiredModules + $RootModule) {
        Remove-Module $Module -Force -ErrorAction "Ignore"
    }
}

task CleanLibrary {
    exec { dotnet clean "./src/Classes/Classes.csproj" }
}

task CleanFiles {
    Remove-Item -Path "./${RootModule}/" -Recurse -Force -ErrorAction "Ignore"
}

task ValidateEnvironment {
}

task LoadRequiredModules {
    foreach ($RequiredModule in $RequiredModules) {
        if ($null -eq (Get-Module -Name $RequiredModule -ListAvailable)) {
            $null = Install-Module -Name $RequiredModule -Scope "CurrentUser"

            Write-Warning -Message "${RequiredModule} was installed."
        }

        Import-Module $RequiredModule -Force
    }
}

task LoadChangeLog {
    assert (Test-Path -Path "./CHANGELOG.md") "Failed to find './CHANGELOG.md'!"

    $Versions = Select-String -Path "./CHANGELOG.md" -Pattern "^## \[(\d\.\d\.\d)\]" |
        Select-Object LineNumber, @{ n = "Value"; e = { $_.Matches.Groups[1].Value } } -First 2

    $Script:ModuleVersion = $Versions[0].Value
    $Script:ReleaseNotes = Get-Content -Path "./CHANGELOG.md" -TotalCount ($Versions[1].LineNumber - 1) |
        Select-Object -Skip $Versions[0].LineNumber
}

task LoadModuleManifest {
    assert (Test-Path -Path "./src/${RootModule}.psd1") "Failed to find './src/${RootModule}.psd1'!"

    $Script:ModuleManifest = Import-PowerShellDataFile -Path "./src/${RootModule}.psd1"

    $Script:ModuleManifest += $ModuleManifest.PrivateData.PSData
    $Script:ModuleManifest.Remove("PrivateData")
}

task BuildLibrary {
    exec { dotnet build "./src/Classes/Classes.csproj" --output "./${RootModule}/${ModuleVersion}/" --property:Version="${ModuleVersion}" --property:Module="${RootModule}" --configuration "Release" }
}

task BuildModule {
    $Script:ModuleFile = New-Item -ItemType "File" -Path "./${RootModule}/${ModuleVersion}/${RootModule}.psm1" -Force

    Add-Content -Path $ModuleFile -Value "#region: Exceptions"
    foreach ($Exception in Get-ChildItem -Path "./src/Exceptions/*.ps1") {
        Add-Content -Path $ModuleFile -Value "#region: $( Resolve-Path -Path $Exception -Relative )"
        Add-Content -Path $ModuleFile -Value (Get-Content -Path $Exception)
        Add-Content -Path $ModuleFile -Value "#endregion"
    }
    Add-Content -Path $ModuleFile -Value "#endregion"

    Add-Content -Path $ModuleFile -Value "#region: Public"
    foreach ($Public in Get-ChildItem -Path "./src/Public/*.ps1") {
        Add-Content -Path $ModuleFile -Value "#region: $( Resolve-Path -Path $Public -Relative )"
        Add-Content -Path $ModuleFile -Value (Get-Content -Path $Public)
        Add-Content -Path $ModuleFile -Value "#endregion"

        $Script:FunctionsToExport += @($Public.BaseName)
    }
    Add-Content -Path $ModuleFile -Value "#endregion"
}

task BuildHelp {
    assert (Test-Path -Path "./docs/") "Failed to find './docs/'!"

    New-ExternalHelp -Path "./docs/" -OutputPath "./${RootModule}/${ModuleVersion}/en-US/" -Force
}

task BuildModuleManifest {
    $Script:ModuleManifest.ModuleVersion = $ModuleVersion
    $Script:ModuleManifest.FunctionsToExport = $FunctionsToExport
    $Script:ModuleManifest.AliasesToExport = [string[]] (Import-Module $ModuleFile -PassThru).ExportedAliases.Keys
    $Script:ModuleManifest.ReleaseNotes = $ReleaseNotes | Out-String

    New-ModuleManifest @ModuleManifest -Path "./${RootModule}/${ModuleVersion}/${RootModule}.psd1"
}

task LoadModule {
    assert (Test-Path -Path "./${RootModule}/${ModuleVersion}/${RootModule}.psd1") "Failed to find './${RootModule}/${ModuleVersion}/${RootModule}.psd1'!"

    Import-Module "./${RootModule}/${ModuleVersion}/${RootModule}.psd1" -Force
}

task AnalyzeModule {
    assert (Test-Path -Path "./${RootModule}/${ModuleVersion}") "Failed to find './${RootModule}/${ModuleVersion}'!"

    Invoke-ScriptAnalyzer -Path "./${RootModule}/${ModuleVersion}"
}

task TestModule {
    assert (Test-Path -Path "./tests/") "Failed to find './docs/'!"

    Invoke-Pester -Path "./tests/"
}


task Configure `
    ValidateEnvironment,
    LoadRequiredModules,
    LoadChangeLog,
    LoadModuleManifest

task Clean `
    CleanModules,
    CleanFiles

task Build `
    BuildLibrary,
    BuildModule,
    BuildHelp,
    BuildModuleManifest,
    CleanLibrary

task Test `
    LoadModule,
    AnalyzeModule,
    TestModule

task . `
    Configure,
    Clean,
    Build,
    Test
