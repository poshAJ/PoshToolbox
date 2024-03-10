param (
    [Parameter()]
    [string]
    $RootModule = "PoshToolbox",

    [Parameter()]
    [version]
    $ModuleVersion = "0.0.0",

    [Parameter()]
    [string]
    $ApiKey
)


task CleanModule {
    Remove-Module $RootModule -Force -ErrorAction "Ignore"
}


task CleanFiles {
    Remove-Item -Path "./${RootModule}/" -Recurse -Force -ErrorAction "Ignore"
}


task CleanLibrary {
    assert (Test-Path -Path "./src/Classes/Classes.csproj")

    exec { dotnet clean "./src/Classes/Classes.csproj" }
}


task LoadChangeLog {
    assert (Test-Path -Path "./CHANGELOG.md")

    $Latest = Select-String -Path "./CHANGELOG.md" -Pattern "^## \[(\d\.\d\.\d)\]" |
        Select-Object LineNumber -First 2

    $Script:ReleaseNotes = Get-Content -Path "./CHANGELOG.md" -TotalCount ($Latest[1].LineNumber - 1) |
        Select-Object -Skip $Latest[0].LineNumber
}


task LoadModuleManifest {
    assert (Test-Path -Path "./src/${RootModule}.psd1")

    $Script:ModuleManifest = Import-PowerShellDataFile -Path "./src/${RootModule}.psd1"

    $Script:ModuleManifest += $ModuleManifest.PrivateData.PSData
    $Script:ModuleManifest.Remove("PrivateData")
}


task BuildLibrary {
    assert (Test-Path -Path "./src/Classes/Classes.csproj")

    exec { dotnet build "./src/Classes/Classes.csproj" --output "./${RootModule}/${ModuleVersion}/" --property:Version="${ModuleVersion}" --property:Module="${RootModule}" --configuration "Release" }
}


task BuildModule {
    $Script:ModuleFile = New-Item -ItemType "File" -Path "./${RootModule}/${ModuleVersion}/${RootModule}.psm1" -Force

    $Groups = Get-ChildItem -Path "./src/*/*.ps1" | Group-Object { $_.Directory.BaseName }
    $Script:FunctionsToExport = $Groups | Where-Object Name -eq "Public" | ForEach-Object { $_.Group.BaseName }

    foreach ($Group in $Groups) {
        Add-Content -Path $ModuleFile -Value "#region: $( $Group.Name )"

        foreach ($File in $Group.Group) {
            Add-Content -Path $ModuleFile -Value "#region: $( Resolve-Path -Path $File -Relative )"
            Add-Content -Path $ModuleFile -Value (Get-Content -Path $File)
            Add-Content -Path $ModuleFile -Value "#endregion"
        }

        Add-Content -Path $ModuleFile -Value "#endregion"
    }
}


task BuildHelp {
    assert (Test-Path -Path "./docs/")

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
    assert (Test-Path -Path "./${RootModule}/${ModuleVersion}/${RootModule}.psd1")

    Import-Module "./${RootModule}/${ModuleVersion}/${RootModule}.psd1" -Force
}


task AnalyzeModule {
    assert (Test-Path -Path "./${RootModule}/${ModuleVersion}")

    Invoke-ScriptAnalyzer -Path "./${RootModule}/${ModuleVersion}"
}


task TestModule {
    assert (Test-Path -Path "./tests/")

    Invoke-Pester -Path "./tests/"
}


task PublishModule {
    assert (Test-Path -Path "./${RootModule}/${ModuleVersion}")

    Publish-PSResource -Path "./${RootModule}/${ModuleVersion}" -Repository "PSGallery" -ApiKey $ApiKey
}


task Clean `
    CleanModule,
    CleanFiles

task Build `
    LoadChangeLog,
    LoadModuleManifest,
    BuildLibrary,
    BuildModule,
    BuildHelp,
    BuildModuleManifest,
    CleanLibrary

task Test `
    Build,
    LoadModule,
    AnalyzeModule,
    TestModule

task Publish `
    Clean,
    Build,
    PublishModule

task . {}
