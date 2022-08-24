# PSIGEL Changelog

## new

### Added

* added support for networkadapters and deviceattributes to Get-UMSDevice
* added support for networkadapters and deviceattributes to Update-UMSDevice

### Changed

* support for german "Umlaute"
* changed casting of properties version to String (Get-UMSStatus and Get-UMSFirmware)

### Fixed

* fixed links to license and online help

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
