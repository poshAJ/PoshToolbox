# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [3.0.0] - 2023-04-08

### Added
+ New-Exception ([#7](https://github.com/PoshAJ/PoshToolbox/pull/7))
    > Creates an instance of ErrorRecord.
+ Split-File ([#11](https://github.com/PoshAJ/PoshToolbox/pull/11))
    > Splits large files into several smaller files.
+ Join-File ([#11](https://github.com/PoshAJ/PoshToolbox/pull/11))
    > Combines split files into their larger source file.
+ ConvertFrom-Base64String ([#14](https://github.com/PoshAJ/PoshToolbox/pull/14))
    > Converts a Base-64 string to a file.
+ ConvertTo-Base64String ([#14](https://github.com/PoshAJ/PoshToolbox/pull/14))
    > Converts a file to a Base-64 string.

### Fixed
+ Typos and Formatting ([#12](https://github.com/PoshAJ/PoshToolbox/pull/12))

### Changed
+ **BREAKING** Resolve-PoshPath ([#9](https://github.com/PoshAJ/PoshToolbox/pull/9))
    > Output changed to result object, similar to the Resolve-Path cmdlet.
+ **BREAKING** Get-FolderProperties ([#9](https://github.com/PoshAJ/PoshToolbox/pull/9))
    > Refactor for Resolve-PoshPath changes.
+ Start-PoshLog ([#13](https://github.com/PoshAJ/PoshToolbox/pull/13))
    > Refactor for Resolve-PoshPath changes.
+ Write-PoshLog ([#13](https://github.com/PoshAJ/PoshToolbox/pull/13))
    > Refactor for Resolve-PoshPath changes.
+ Stop-PoshLog ([#13](https://github.com/PoshAJ/PoshToolbox/pull/13))
    > Refactor for Resolve-PoshPath changes.

## [2.0.0] - 2023-04-02
Project name change, previous versions known as `ScriptFramework`.

### Added
+ Find-NlMtu ([#3](https://github.com/PoshAJ/PoshToolbox/pull/3))
    > Discovers the network layer maximum transmission unit (MTU) size.
+ Get-FileFolder ([#4](https://github.com/PoshAJ/PoshToolbox/pull/4))
    > Displays file folder information.

### Fixed
+ Typos and Code Formatting ([#5](https://github.com/PoshAJ/PoshToolbox/pull/5))

### Changed
+ Error Handling ([#2](https://github.com/PoshAJ/PoshToolbox/pull/2))
