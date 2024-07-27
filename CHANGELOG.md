# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## Unreleased

### Added

- Add OutputType for `Find-NlMtu`, `Get-FolderProperties`, and `Resolve-PoshPath` [#37](https://gitlab.com/PoshAJ/PoshToolbox/-/issues/37)

### Fixed

- Fix OutputType for `Join-File`, `Split-File`, `New-IPAddress` and `New-IPSubnet` [#37](https://gitlab.com/PoshAJ/PoshToolbox/-/issues/37)

### Changed

- Use-Ternary [#33](https://gitlab.com/PoshAJ/PoshToolbox/-/issues/33)
  > `IfTrue` and `IfFalse` parameters are no longer mandatory.
- Get-FolderProperties [!42](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/42)
  > `Unit` parameter is no longer mandatory.

## [4.2.3](https://www.powershellgallery.com/packages/PoshToolbox/4.2.3) - 2024-07-15

### Fixed

- Fix Linux Compatibility and Test Suite [#31](https://gitlab.com/PoshAJ/PoshToolbox/-/issues/31)
- General Format and Consistency [#35](https://gitlab.com/PoshAJ/PoshToolbox/-/issues/35)
- Fix Function Execution Inside Module Scope [!41](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/41)
- Fix OutOfMemory Exception for `Convert-Base64String` [#36](https://gitlab.com/PoshAJ/PoshToolbox/-/issues/36)

### Changed

- Use-ErrorCoalescing [#32](https://gitlab.com/PoshAJ/PoshToolbox/-/issues/32)
  > Allow specific error branching utilizing hashtable input.

## [4.2.2](https://www.powershellgallery.com/packages/PoshToolbox/4.2.2) - 2024-03-07

### Fixed

- Cmdlets using `Write-Output` with the `-NoEmunerate` switch would wrap `hashtable` in ``List`1`` [#30](https://gitlab.com/PoshAJ/PoshToolbox/-/issues/30)

## [4.2.1](https://www.powershellgallery.com/packages/PoshToolbox/4.2.1) - 2024-03-06

### Fixed

- Use-NullCoalescing isn't Consistent for Undefined Objects [#29](https://gitlab.com/PoshAJ/PoshToolbox/-/issues/29)

### Changed

- Repository updated for GitLab [!28](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/28)

## [4.2.0](https://www.powershellgallery.com/packages/PoshToolbox/4.2.0) - 2023-12-08

### Added

- Use-ErrorCoalescing [#27](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/27)
  > Implements an Error-coalescing operator (?!).

### Changed

- New-IPSubnet [!26](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/26)
  > Refactor for class implementation.
- Invoke-ExponentialBackoff [!26](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/26)
  > Refactor for class implementation.
- Implemented [InvokeBuild](https://github.com/nightroman/Invoke-Build) [!26](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/26)

## [4.1.0](https://www.powershellgallery.com/packages/PoshToolbox/4.1.0) - 2023-08-05

### Added

- New-IPAddress [!23](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/23)
  > Creates an IPAddress object.
- New-IPSubnet [!23](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/23)
  > Creates an IPSubnet object.

### Fixed

- Updated reference to Exception for `New-Exception` [!21](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/21)
- Refactored Tests [!22](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/22)

## [4.0.1](https://www.powershellgallery.com/packages/PoshToolbox/4.0.1) - 2023-08-02

### Fixed

- Updated reference to Marshal for `Get-ADServiceAccountCredential` [!20](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/20)

## [4.0.0](https://www.powershellgallery.com/packages/PoshToolbox/4.0.0) - 2023-07-28

### Added

- Invoke-ExponentialBackoff [!15](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/15)
  > Executes a scriptblock implementing retries with exponential backoff.

### Fixed

- Updated Code Formatting for `Use-Object` [!17](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/17)
- Updated Code Logic for `Resolve-PoshPath` [!18](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/18)
- Updated Repository Structure and Refactored to reduce `using namespace` [!19](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/19)

### Changed

- **BREAKING** ConvertTo-Base64String [!16](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/16)
  > Refactor to align with other ConvertTo-\* cmdlets.
- **BREAKING** ConvertFrom-Base64String [!16](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/16)
  > Refactor to align with other ConvertFrom-\* cmdlets.

## [3.0.0](https://www.powershellgallery.com/packages/PoshToolbox/3.0.0) - 2023-04-08

### Added

- New-Exception [!7](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/7)
  > Creates an instance of ErrorRecord.
- Split-File [!11](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/11)
  > Splits large files into several smaller files.
- Join-File [!11](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/11)
  > Combines split files into their larger source file.
- ConvertFrom-Base64String [!14](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/14)
  > Converts a Base-64 string to a file.
- ConvertTo-Base64String [!14](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/14)
  > Converts a file to a Base-64 string.

### Fixed

- Typos and Formatting [!12](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/12)

### Changed

- **BREAKING** Resolve-PoshPath [!9](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/9)
  > Output changed to result object, similar to the Resolve-Path cmdlet.
- **BREAKING** Get-FolderProperties [!9](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/9)
  > Refactor for Resolve-PoshPath changes.
- Start-PoshLog [!13](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/13)
  > Refactor for Resolve-PoshPath changes.
- Write-PoshLog [!13](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/13)
  > Refactor for Resolve-PoshPath changes.
- Stop-PoshLog [!13](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/13)
  > Refactor for Resolve-PoshPath changes.

## [2.0.0](https://www.powershellgallery.com/packages/PoshToolbox/2.0.0) - 2023-04-02

Project name change, previous versions known as `ScriptFramework`.

### Added

- Find-NlMtu [!3](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/3)
  > Discovers the network layer maximum transmission unit (MTU) size.
- Get-FolderProperties [!4](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/4)
  > Displays file folder information.

### Fixed

- Typos and Code Formatting [!5](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/5)

### Changed

- Error Handling [!2](https://gitlab.com/PoshAJ/PoshToolbox/-/merge_requests/2)
