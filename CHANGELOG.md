# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## Unreleased

### Changed

- New-IPSubnet ([#26](https://github.com/PoshAJ/PoshToolbox/pull/26))
  > Refactor for class implementation.
- Invoke-ExponentialBackoff ([#26](https://github.com/PoshAJ/PoshToolbox/pull/26))
  > Refactor for class implementation.
- Implemented [InvokeBuild](https://github.com/nightroman/Invoke-Build) ([#26](https://github.com/PoshAJ/PoshToolbox/pull/26))

## [4.1.0](https://www.powershellgallery.com/packages/PoshToolbox/4.1.0) - 2023-08-05

### Added

- New-IPAddress ([#23](https://github.com/PoshAJ/PoshToolbox/pull/23))
  > Creates an IPAddress object.
- New-IPSubnet ([#23](https://github.com/PoshAJ/PoshToolbox/pull/23))
  > Creates an IPSubnet object.

### Fixed

- Updated reference to Exception for `New-Exception` ([#21](https://github.com/PoshAJ/PoshToolbox/pull/21))
- Refactored Tests. ([#22](https://github.com/PoshAJ/PoshToolbox/pull/22))

## [4.0.1](https://www.powershellgallery.com/packages/PoshToolbox/4.0.1) - 2023-08-02

### Fixed

- Updated reference to Marshal for `Get-ADServiceAccountCredential` ([#20](https://github.com/PoshAJ/PoshToolbox/pull/20))

## [4.0.0](https://www.powershellgallery.com/packages/PoshToolbox/4.0.0) - 2023-07-28

### Added

- Invoke-ExponentialBackoff ([#15](https://github.com/PoshAJ/PoshToolbox/pull/15))
  > Executes a scriptblock implementing retries with exponential backoff.

### Fixed

- Updated Code Formatting for `Use-Object` ([#17](https://github.com/PoshAJ/PoshToolbox/pull/17))
- Updated Code Logic for `Resolve-PoshPath` ([#18](https://github.com/PoshAJ/PoshToolbox/pull/18))
- Updated Repository Structure and Refactored to reduce `using namespace` ([#19](https://github.com/PoshAJ/PoshToolbox/pull/19))

### Changed

- **BREAKING** ConvertTo-Base64String ([#16](https://github.com/PoshAJ/PoshToolbox/pull/16))
  > Refactor to align with other ConvertTo-\* cmdlets.
- **BREAKING** ConvertFrom-Base64String ([#16](https://github.com/PoshAJ/PoshToolbox/pull/16))
  > Refactor to align with other ConvertFrom-\* cmdlets.

## [3.0.0](https://www.powershellgallery.com/packages/PoshToolbox/3.0.0) - 2023-04-08

### Added

- New-Exception ([#7](https://github.com/PoshAJ/PoshToolbox/pull/7))
  > Creates an instance of ErrorRecord.
- Split-File ([#11](https://github.com/PoshAJ/PoshToolbox/pull/11))
  > Splits large files into several smaller files.
- Join-File ([#11](https://github.com/PoshAJ/PoshToolbox/pull/11))
  > Combines split files into their larger source file.
- ConvertFrom-Base64String ([#14](https://github.com/PoshAJ/PoshToolbox/pull/14))
  > Converts a Base-64 string to a file.
- ConvertTo-Base64String ([#14](https://github.com/PoshAJ/PoshToolbox/pull/14))
  > Converts a file to a Base-64 string.

### Fixed

- Typos and Formatting ([#12](https://github.com/PoshAJ/PoshToolbox/pull/12))

### Changed

- **BREAKING** Resolve-PoshPath ([#9](https://github.com/PoshAJ/PoshToolbox/pull/9))
  > Output changed to result object, similar to the Resolve-Path cmdlet.
- **BREAKING** Get-FolderProperties ([#9](https://github.com/PoshAJ/PoshToolbox/pull/9))
  > Refactor for Resolve-PoshPath changes.
- Start-PoshLog ([#13](https://github.com/PoshAJ/PoshToolbox/pull/13))
  > Refactor for Resolve-PoshPath changes.
- Write-PoshLog ([#13](https://github.com/PoshAJ/PoshToolbox/pull/13))
  > Refactor for Resolve-PoshPath changes.
- Stop-PoshLog ([#13](https://github.com/PoshAJ/PoshToolbox/pull/13))
  > Refactor for Resolve-PoshPath changes.

## [2.0.0](https://www.powershellgallery.com/packages/PoshToolbox/2.0.0) - 2023-04-02

Project name change, previous versions known as `ScriptFramework`.

### Added

- Find-NlMtu ([#3](https://github.com/PoshAJ/PoshToolbox/pull/3))
  > Discovers the network layer maximum transmission unit (MTU) size.
- Get-FileFolder ([#4](https://github.com/PoshAJ/PoshToolbox/pull/4))
  > Displays file folder information.

### Fixed

- Typos and Code Formatting ([#5](https://github.com/PoshAJ/PoshToolbox/pull/5))

### Changed

- Error Handling ([#2](https://github.com/PoshAJ/PoshToolbox/pull/2))
