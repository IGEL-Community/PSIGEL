# PSIGEL

This is a module to interact with the IGEL UMS API (via IGEL IMI) or MSSQL-Database.

The **API** uses a cookie as authentication. You can create it with [New-UMSAPICookie](#new-umsapicookie):

```powershell
$Websession = New-UMSAPICookie -Computername UMSSERVER -TCPPort 8443 -Username igelums
```

If you did not provide a websession-cookie, one will be created.

To connect to the **MSSQL** Database it may be required to provide credential:

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
```

If you did not provide a credential, one will be created.

My goal is to support all the [API-functionalities](http://edocs.igel.com/manuals/en/en_imi_ref/index.htm#14276.htm). If there is only a MSSQL-Query to provide a functionality, than there will be a MSSQL-only function. Suggestions are welcome.

## API

* Get-UMSFirmware
* Get-UMSProfile
* Get-UMSProfileAssignment
* Get-UMSStatus
* Get-UMSThinclient
* Get-UMSThinclientAssignment
* Get-UMSThinclientDirectory
* New-UMSAPICookie
* New-UMSThinclient
* Remove-UMSProfile
* Remove-UMSProfileAssignment
* Remove-UMSThinclient
* Remove-UMSThinclientDirectory
* Reset-UMSThinclient
* Restart-UMSThinclient
* Send-UMSThinclientSetting
* Start-UMSThinclient
* Stop-UMSThinclient
* Update-UMSProfileAssignment
* Update-UMSProfileName
* Update-UMSThinclient
* Update-UMSThinclientDirectoryName

## MSSQL

* Get-UMSJob
* Get-UMSView
* Update-UMSJobStartDate

## Scripts

* GetUMSDirectoryStructure

## Other

* Invoke-Sqlcmd2

used for SQL queries

from [RamblingCookieMonster](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1)

 > Runs a T-SQL script. Invoke-Sqlcmd2 runs the whole scipt and only captures the first selected result set, such as the output of PRINT statements when -verbose parameter is specified.
Paramaterized queries are supported.

* Invoke-UMSRestMethodWebSession