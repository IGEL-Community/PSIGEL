# PSIGEL

This is a module to interact with the IGEL UMS API (via IGEL IMI), the UMS MSSQL-Database (until the API supports all functions) and the IGEL OS Endpoints (e.g. Endpoints) via SSH.

**API (/MSSQL)** functions got the noun-prefix **UMS** (for Universal Management Server), e.g. Get-**UMS**Something

**SSH** functions got the noun-prefix **EP** (for EndPoint), e.g. Get-**EP**Something

To connect to the Endpoints via **SSH**, the Module [Posh-SSH](https://github.com/darkoperator/Posh-SSH) by Carlos Perez aka darkoperator is required.

The **API** uses a cookie as authentication. You can create it with [New-UMSAPICookie](#new-umsapicookie):

```powershell
$Websession = New-UMSAPICookie -Computername UMSSERVER -TCPPort 8443
```

If you did not provide a websession-cookie, one will be created.

To connect to the **MSSQL** Database it may be required to provide credential:

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
```

If you did not provide a credential, one will be created.

My goal is to support all the [API-functionalities](http://edocs.igel.com/manuals/en/en_imi_ref/index.htm#14276.htm). If there is only a MSSQL-Query to provide a functionality, than there will be a MSSQL-only function. Suggestions are welcome.

## Installation

If you have the [PowerShellGet](https://github.com/powershell/powershellget) module installed you can enter the following command:

```powershell
Install-Module -Name PSIGEL
```

Alternatively you can download a ZIP file of the latest version from our [Releases](https://github.com/IGEL-Community/PSIGEL/releases) page.

## API(/MSSQL) Functionality

### API General

Item | Get | New
-----|-----|----
WebSession |-|[API](#new-umsapicookie)
Status |[API](#get-umsstatus)|-
Firmware |[API](#get-umsfirmware)|-

### API Thin Client

Item | Get | New | Update | Move | Remove | Start | Restart | Settings | Stop | Reset
-----|-----|-----|--------|------|--------|-------|---------|----------|------|------
Thin Client |[API](#get-umsendpoint)|[API](#new-umsendpoint)|[API](#update-umsendpoint)|[API](#move-umsendpoint)|[API](#remove-umsendpoint)|[API](#start-umsendpoint)|[API](#restart-umsendpoint)|[API](#send-umsendpointsetting)|[API](#stop-umsendpoint)|[API](#reset-umsendpoint)

### API/SQL Other Items

Item | Get | New | Update | Move | Remove
-----|-----|-----|--------|------|-------
Profile |[API](#get-umsprofile)|-|[API](#remove-umsprofileassignment)|[API](#move-umsprofile)|[API](#remove-umsprofile)
Profile Directory |[API](#get-umsprofileDirectory)|[API](#new-umsprofiledirectory)|[API](#update-umsprofiledirectoryname)|[API](#move-umsprofiledirectory)|[API](#remove-umsprofiledirectory)
Master Profile |API|-|API|API|API
Master Profile Directory |API|API|API|API|API
Thin Client Directory |[API](#get-umsendpointdirectory)|[API](#new-umsendpointdirectory)|[API](#update-umsendpointdirectoryname)|[API](#move-umsendpointdirectory)|[API](#remove-umsendpointdirectory)
|View |[SQL](#get-umsview)|-|SQL|-|-
View Directory |[SQL](#get-umsviewdirectory)|-|SQL|-|-
Job |[SQL](#get-umsjob)|-|[SQL](#update-umsjobstartdate)|-|-
Job Directory |[SQL](#Get-umsjobdirectory)|-|SQL|-|-
File |[SQL](#get-umsfile)|-|-|-|-
File Directory |[SQL](#get-umsfiledirectory)|-|-|-|-

### API Assignment

|Item | Get | Update | Remove
|-----|-----|--------|-------
Thin Client |[API](#get-umsendpointassignment) |-|-
Thin Client Directory |[API](#get-umsendpointdirectoryassignment) |-|-
Profile |[API](#get-umsprofileassignment) |[API](#update-umsprofileassignment) |[API](#remove-umsprofileassignment)
Master Profile |API|-|-

## Functions

### [Get-EPFirmware](/Docs/Get-EPFirmware.md)

Get Firmware

### [Get-EPUpdateConfiguration](/Docs/Get-EPUpdateConfiguration.md)

Get update configuration (IGEL OS 10+)

### [Get-EPWifiConnection](/Docs/Get-EPWifiConnection.md)

Get Wifi connection information

### [Get-UMSFile](/Docs/Get-UMSFile.md)

Get Files.

### [Get-UMSFileDirectory](/Docs/Get-UMSFileDirectory.md)

Get File Directories.

### [Get-UMSFirmware](/Docs/Get-UMSFirmware.md)

Get information on all firmwares known to the UMS.

### [Get-UMSJob](/Docs/Get-UMSJob.md)

Get Jobs.

### [Get-UMSJobDirectory](/Docs/Get-UMSJobDirectory.md)

Get Job Directories.

### [Get-UMSProfile](/Docs/Get-UMSProfile.md)

Get information on profiles on the UMS instance.

### [Get-UMSProfileAssignment](/Docs/Get-UMSProfileAssignment.md)

Get the Endpoints and directories the profile is assigned to.

### [Get-UMSProfileDirectory](/Docs/Get-UMSProfileDirectory.md)

Get information on Profile Directories.

### [Get-UMSStatus](/Docs/Get-UMSStatus.md)

Get diagnostic information about the UMS instance.

### [Get-UMSEndpoint](/Docs/Get-UMSEndpoint.md)

Get Endpoints.

### [Get-UMSEndpointAssignment](/Docs/Get-UMSEndpointAssignment.md)

Get the profile and master profile assignments for the specified thin client, in order of their application.

### [Get-UMSEndpointDirectory](/Docs/Get-UMSEndpointDirectory.md)

Get information on Thin Client Directories.

### [Get-UMSEndpointDirectoryAssignment](/Docs/Get-UMSEndpointDirectoryAssignment.md)

Get the profile and master profile assignments for the specified thincient directory, in order of their application.

### [Get-UMSView](/Docs/Get-UMSView.md)

Get Views.

### [Get-UMSViewDirectory](/Docs/Get-UMSViewDirectory.md)

Get View Directories.

### [Move-UMSProfile](/Docs/Move-UMSProfile.md)

Moves Profiles into the specified Profile Directory.

### [Move-UMSProfileDirectory](/Docs/Move-UMSProfileDirectory.md)

Moves Profile Directories into the specified Profile Directory.

### [Move-UMSEndpoint](/Docs/Move-UMSEndpoint.md)

Moves Endpoints into the specified Endpoint Directory.

### [Move-UMSEndpointDirectory](/Docs/Move-UMSEndpointDirectory.md)

Moves Endpoint Directories into the specified Endpoint Directory.

### [New-UMSAPICookie](/Docs/New-UMSAPICookie.md)

Creates Websession Cookie for IGEL UMS RestAPI.

### [New-UMSProfileDirectory](/Docs/New-UMSProfileDirectory.md)

Creates a Profile Directory.

### [New-UMSEndpoint](/Docs/New-UMSEndpoint.md)

Creates a new ThinClient.

### [New-UMSEndpointDirectory](/Docs/New-UMSEndpointDirectory.md)

Creates a Endpoint Directory.

### [Remove-UMSProfile](/Docs/Remove-UMSProfile.md)

Deletes profile.

### [Remove-UMSProfileAssignment](/Docs/Remove-UMSProfileAssignment.md)

Deletes assignment of the specified profile to the specified Endpoint or Endpoint directory.

### [Remove-UMSProfileDirectory](/Docs/Remove-UMSProfileDirectory.md)

Removes a profile directory.

### [Remove-UMSEndpoint](/Docs/Remove-UMSEndpoint.md)

Removes a Endpoint completely (without recycle bin).

### [Remove-UMSEndpointDirectory](/Docs/Remove-UMSEndpointDirectory.md)

Removes a Endpoint directory.

### [Reset-UMSEndpoint](/Docs/Reset-UMSEndpoint.md)

Resets all thin clients listed in the request body to factory defaults and removes them from the UMS completely (without recycle bin).

### [Restart-UMSEndpoint](/Docs/Restart-UMSEndpoint.md)

Restarts Endpoints.

### [Send-UMSEndpointSetting](/Docs/Send-UMSEndpointSetting.md)

Sends settings modified in the UMS database to all thin clients listed in the request body immediately.

### [Start-UMSEndpoint](/Docs/Start-UMSEndpoint.md)

Wakes Up Endpoints (WOL).

### [Stop-UMSEndpoint](/Docs/Stop-UMSEndpoint.md)

Shuts Down Endpoints.

### [Update-UMSJobStartDate](/Docs/Update-UMSJobStartDate.md)

Update Job Startdate.

### [Update-UMSProfileAssignment](/Docs/Update-UMSProfileAssignment.md)

Assigns a profile to a Endpoint or a Endpoint directory.

### [Update-UMSProfileDirectoryName](/Docs/Update-UMSProfileDirectoryName.md)

Updates a Profile Directory name.

### [Update-UMSProfileName](/Docs/Update-UMSProfileName.md)

Updates a profile name.

### [Update-UMSEndpoint](/Docs/Update-UMSEndpoint.md)

Updates properties of a Endpoint.

### [Update-UMSEndpointDirectoryName](/Docs/Update-UMSEndpointDirectoryName.md)

Updates a Profile Directory name.

## Scripts

### [GetEndpointWifiInformationViaSSH](/Docs/GetEndpointWifiInformationViaSSH.md)

Get Endpoint WiFi Information via SSH.

### GetUMSDirectoryStructure

Get Endpoint Directory Structure. Expects 4 Tier-Directory Structure . (e.g. Base / Organisation / Campus / Room)

### RemoveParallelAppliedProfiles

Removes Profiles from Endpoints if they are applied parallel.

## Private functions

### Invoke-Sqlcmd2

used for SQL queries

from [RamblingCookieMonster](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1)

 > Runs a T-SQL script. Invoke-Sqlcmd2 runs the whole scipt and only captures the first selected result set, such as the output of PRINT statements when -verbose parameter is specified.
Paramaterized queries are supported.

### Invoke-UMSRestMethodWebSession

Invoke-RestMethod Wrapper
