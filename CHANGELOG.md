# PSIGEL Changelog

## new

### Changed

* support  for german "Umlaute"

## v0.10.0 - 20200429

### Added

* cross platform support (Windows, Linux, MacOS)
* support for Powershell 7
* Remove-UMSAPICookie
* Site, Department, CostCenter, AssetID, InServiceDate and SerialNumber to Get-UMSDevice -Filter details
* support for Datatype Version in Get-UMSFirmware, Get-UMSStatus
* Get-UMSDirectoryRecursive

### Changed

* set minimum Powershell Requirement for the module to 5.1
* SerialNumber Length to 18

### Fixed

* reset / update empty values of devices

### Removed

* remove \*-OS\* functions
