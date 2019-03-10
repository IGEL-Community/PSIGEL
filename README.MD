# PSIGEL

This is a module to interact with the IGEL UMS via API and IGEL OS Devices via SSH.

**API** functions got the noun-prefix **UMS** (for Universal Management Server), e.g. Get-**UMS**Something

**SSH** functions got the noun-prefix **OS** (for Device), e.g. Get-**OS**Something

To connect to the Devices via **SSH**, the Module [Posh-SSH](https://github.com/darkoperator/Posh-SSH) by Carlos Perez aka darkoperator is required.

The **API** uses a cookie as authentication. You can create it with [New-UMSAPICookie](/#new-umsapicookie):

```powershell
$Websession = New-UMSAPICookie -Computername igelrmserver
```

My goal is to support all [API-functionalities](https://kb.igel.com/igelimi-v3/en/imi-api-v3-reference-2723425.html) IGEL provides. Use at own risk! Suggestions are welcome.

## Installation

If you have the [PowerShellGet](https://github.com/powershell/powershellget) module installed you can enter the following command:

```powershell
Install-Module -Name PSIGEL
```

Alternatively you can download a ZIP file of the latest version from our [Releases](https://github.com/IGEL-Community/PSIGEL/releases) page.

## PSIGEL Cmdlets
### [Get-OSFirmware](/Docs/Get-OSFirmware.md)
Gets firmware from a device.

### [Get-OSUpdateConfiguration](/Docs/Get-OSUpdateConfiguration.md)
Gets firmware from a device.

### [Get-OSWifiConnection](/Docs/Get-OSWifiConnection.md)
Gets wifi connection from a device.

### [Get-UMSDevice](/Docs/Get-UMSDevice.md)
Gets information on a device.

### [Get-UMSDeviceAssignment](/Docs/Get-UMSDeviceAssignment.md)
Gets information on a profile or master profile assignment of a device.

### [Get-UMSDeviceDirectory](/Docs/Get-UMSDeviceDirectory.md)
Gets information on a device directory.

### [Get-UMSDeviceDirectoryAssignment](/Docs/Get-UMSDeviceDirectoryAssignment.md)
Gets information on a profile or master profile assignment of a device directory.

### [Get-UMSFirmware](/Docs/Get-UMSFirmware.md)
Gets information on a firmware.

### [Get-UMSProfile](/Docs/Get-UMSProfile.md)
Gets information on a profile.

### [Get-UMSProfileAssignment](/Docs/Get-UMSProfileAssignment.md)
Gets information on a device or device directory assignment of a profile.

### [Get-UMSProfileDirectory](/Docs/Get-UMSProfileDirectory.md)
Gets information on a profile directory.

### [Get-UMSStatus](/Docs/Get-UMSStatus.md)
Gets information on the UMS.

### [Move-UMSDevice](/Docs/Move-UMSDevice.md)
Moves a device to a device directory.

### [Move-UMSDeviceDirectory](/Docs/Move-UMSDeviceDirectory.md)
Moves a device directory to a device directory.

### [Move-UMSProfile](/Docs/Move-UMSProfile.md)
Moves a profile to a profile directory.

### [Move-UMSProfileDirectory](/Docs/Move-UMSProfileDirectory.md)
Moves a profile directory to profile directory.

### [New-UMSAPICookie](/Docs/New-UMSAPICookie.md)
Creates a websession cookie.

### [New-UMSDevice](/Docs/New-UMSDevice.md)
Creates a new device.

### [New-UMSDeviceDirectory](/Docs/New-UMSDeviceDirectory.md)
Creates a device directory.

### [New-UMSProfileAssignment](/Docs/New-UMSProfileAssignment.md)
Creates a profile assignment on a device or device directory.

### [New-UMSProfileDirectory](/Docs/New-UMSProfileDirectory.md)
Creates a profile directory.

### [Remove-UMSDevice](/Docs/Remove-UMSDevice.md)
Removes a device.

### [Remove-UMSDeviceDirectory](/Docs/Remove-UMSDeviceDirectory.md)
Removes a device directory.

### [Remove-UMSProfile](/Docs/Remove-UMSProfile.md)
Removes a profile.

### [Remove-UMSProfileAssignment](/Docs/Remove-UMSProfileAssignment.md)
Removes a profile assignment from a device or device directory.

### [Remove-UMSProfileDirectory](/Docs/Remove-UMSProfileDirectory.md)
Removes a profile directory.

### [Reset-UMSDevice](/Docs/Reset-UMSDevice.md)
Resets a device to factory defaults.

### [Restart-UMSDevice](/Docs/Restart-UMSDevice.md)
Restarts a device.

### [Send-UMSDeviceSetting](/Docs/Send-UMSDeviceSetting.md)
Sends settings to a device.

### [Start-UMSDevice](/Docs/Start-UMSDevice.md)
Wakes up a device.

### [Stop-UMSDevice](/Docs/Stop-UMSDevice.md)
Shuts down a device.

### [Update-UMSDevice](/Docs/Update-UMSDevice.md)
Updates properties of a device.

### [Update-UMSDeviceDirectory](/Docs/Update-UMSDeviceDirectory.md)
Updates the name of a device directory.

### [Update-UMSProfile](/Docs/Update-UMSProfile.md)
Updates the name of a profile.

### [Update-UMSProfileDirectory](/Docs/Update-UMSProfileDirectory.md)
Updates the name of a profile directory.