# PSIGEL

This is a module to interact with the IGEL UMS API (via IGEL IMI), the UMS MSSQL-Database (until the API supports all functions) and the IGEL OS Endpoints (e.g. Thinclients) via SSH.

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
Thin Client |[API](#get-umsthinclient)|[API](#new-umsthinclient)|[API](#update-umsthinclient)|[API](#move-umsthinclient)|[API](#remove-umsthinclient)|[API](#start-umsthinclient)|[API](#restart-umsthinclient)|[API](#send-umsthinclientsetting)|[API](#stop-umsthinclient)|[API](#reset-umsthinclient)

### API/SQL Other Items

Item | Get | New | Update | Move | Remove
-----|-----|-----|--------|------|-------
Profile |[API](#get-umsprofile)|-|[API](#remove-umsprofileassignment)|[API](#move-umsprofile)|[API](#remove-umsprofile)
Profile Directory |[API](#get-umsprofileDirectory)|[API](#new-umsprofiledirectory)|[API](#update-umsprofiledirectoryname)|[API](#move-umsprofiledirectory)|[API](#remove-umsprofiledirectory)
Master Profile |API|-|API|API|API
Master Profile Directory |API|API|API|API|API
Thin Client Directory |[API](#get-umsthinclientdirectory)|[API](#new-umsthinclientdirectory)|[API](#update-umsthinclientdirectoryname)|[API](#move-umsthinclientdirectory)|[API](#remove-umsthinclientdirectory)
|View |[SQL](#get-umsview)|-|SQL|-|-
View Directory |[SQL](#get-umsviewdirectory)|-|SQL|-|-
Job |[SQL](#get-umsjob)|-|[SQL](#update-umsjobstartdate)|-|-
Job Directory |[SQL](#Get-umsjobdirectory)|-|SQL|-|-
File |[SQL](#get-umsfile)|-|-|-|-
File Directory |[SQL](#get-umsfiledirectory)|-|-|-|-

### API Assignment

|Item | Get | Update | Remove
|-----|-----|--------|-------
Thin Client |[API](#get-umsthinclientassignment) |-|-
Thin Client Directory |[API](#get-umsthinclientdirectoryassignment) |-|-
Profile |[API](#get-umsprofileassignment) |[API](#update-umsprofileassignment) |[API](#remove-umsprofileassignment)
Master Profile |API|-|-

## Functions

### Get-EPFirmware

Get Firmware

### Get-EPUpdateConfiguration

Get update configuration (IGEL OS 10+)

### Get-EPWifiConnection

[Get Wifi connection information](../Docs/Get-EPWifiConnection.md)

### Get-UMSFile

Gets Files.

### Get-UMSFileDirectory

Gets File Directories.

### Get-UMSFirmware

Gets information on all firmwares known to the UMS.

### Get-UMSJob

Gets Jobs.

### Get-UMSJobDirectory

Gets Job Directories.

### Get-UMSProfile

Gets information on profiles on the UMS instance.

### Get-UMSProfileAssignment

Gets the thinclients and directories the profile is assigned to.

### Get-UMSProfileDirectory

Gets information on Profile Directories.

### Get-UMSStatus

Gets diagnostic information about the UMS instance. Server status is the only resource that can be queried without logging in. This makes it useful for debugging the connection to the IMI service.

### Get-UMSThinclient

Gets Thinclients.

### Get-UMSThinclientAssignment

Gets the profile and master profile assignments for the specified thin client, in order of their application.

### Get-UMSThinclientDirectory

Gets information on Thin Client Directories.

### Get-UMSThinclientDirectoryAssignment

Gets the profile and master profile assignments for the specified thincient directory, in order of their application.

### Get-UMSView

Gets Views.

### Get-UMSViewDirectory

Gets View Directories.

### Move-UMSProfile

Moves Profiles into the specified Profile Directory.

### Move-UMSProfileDirectory

Moves Profile Directories into the specified Profile Directory.

### Move-UMSThinclient

Moves Thinclients into the specified Thinclient Directory.

### Move-UMSThinclientDirectory

Moves Thinclient Directories into the specified Thinclient Directory.

### New-UMSAPICookie

Creates Websession Cookie for IGEL UMS RestAPI.

### New-UMSProfileDirectory

Creates a Profile Directory.

### New-UMSThinclient

Creates a new ThinClient.

### New-UMSThinclientDirectory

Creates a Thinclient Directory.

### Remove-UMSProfile

Deletes profile.

### Remove-UMSProfileAssignment

Deletes assignment of the specified profile to the specified Thinclient or Thinclient directory.

### Remove-UMSProfileDirectory

Removes a profile directory.

### Remove-UMSThinclient

Removes a Thinclient completely (without recycle bin).

### Remove-UMSThinclientDirectory

Removes a Thinclient directory.

### Reset-UMSThinclient

Resets all thin clients listed in the request body to factory defaults and removes them from the UMS completely (without recycle bin).

### Restart-UMSThinclient

Restarts Thinclients.

### Send-UMSThinclientSetting

Sends settings modified in the UMS database to all thin clients listed in the request body immediately.

### Start-UMSThinclient

Wakes Up Thinclients (WOL).

### Stop-UMSThinclient

Shuts Down Thinclients.

### Update-UMSJobStartDate

Update Job Startdate.

### Update-UMSProfileAssignment

Assigns a profile to a Thinclient or a Thinclient directory.

### Update-UMSProfileDirectoryName

Updates a Profile Directory name.

### Update-UMSProfileName

Updates a profile name.

### Update-UMSThinclient

Updates properties of a Thinclient

### Update-UMSThinclientDirectoryName

Updates a Profile Directory name.

## Scripts

### GetUMSDirectoryStructure

Gets Thinclient Directory Structure. Expects 4 Tier-Directory Structure (e.g. Base / Organisation / Campus / Room)

## Private functions

### Invoke-Sqlcmd2

used for SQL queries

from [RamblingCookieMonster](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1)

 > Runs a T-SQL script. Invoke-Sqlcmd2 runs the whole scipt and only captures the first selected result set, such as the output of PRINT statements when -verbose parameter is specified.
Paramaterized queries are supported.

### Invoke-UMSRestMethodWebSession

Invoke-RestMethod Wrapper