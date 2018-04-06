# PSIGEL

This is a module to interact with the IGEL UMS API (via IGEL IMI) and/or MSSQL-Database.

## Invoke-UMSThinclientUpdate
[automates specific Thinclient Update mechanism](/docs/InvokeUMSThinclientUpdate.md)

## New-UMSAPICookie
Creates Websession Cookie for IGEL UMS API

**Asks for Password and creates Cookie-Object for use in API-Functions**

    New-UMSAPICookie -Computername UMSSERVER -TCPPort 8443 -Username igelums -ApiVersion 3

## Get-UMSThinclient
Gets Thinclient from UMS API and/or MSSQL-Database

**Gets detailed information on all online thin clients**

    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Details 'full' | Out-GridView

**Gets short information on thin clients with TCID 2433**

    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433

**Gets shadow-information on Thinclient with TCID 2433**

    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    2433 | Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Details 'shadow'

**Gets all Thinclients**
   
    Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' | Out-GridView
      
**Asks for Credential and gets Thinclient with TCID 2433**
    
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -TCID 2433 -Credential $Credential
      
**Gets Thinclient with TCID 2433**
    
    433 | Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'

## Get-UMSThinclientAssignment
Gets the profile and master profile assignments for the specified thin client, in order of their application from Rest API.

**Gets the profile and master profile assignments for Thinclient with TCID 243**

    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    Get-UMSThinclientAssignment -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433 | Out-GridView

**Gets the profile and master profile assignments for Thinclient with TCID 2433**

    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    2433 | Get-UMSThinclientAssignment -Computername 'UMSSERVER' -WebSession $WebSession

## New-UMSThinclient
Creates a new thinclient from Rest API

**Creates new thinclient with mac and firmareid (minimal requirements) in the root directory**

    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    New-UMSThinclient -Computername $Computername -WebSession $WebSession -Mac 012345678910 -FirmwareID 9

**Creates new thinclient with all possible attributes**

    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    $NewUMSThinclientParams = @{
      Computername  = 'UMSSERVER'
      WebSession    =  $WebSession
      Mac           = '012345678910'
      FirmwareID    = '9'
      Name          = 'TC012345'
      ParentID      = '772'
      Site          = 'Leipzig'
      Department    = 'Marketing'
      CostCenter    = '50100'
      LastIP        = '192.168.0.10'
      Comment       = 'New Thinclient'
      AssetID       = '012345'
      InserviceDate = '01.01.2018'
      SerialNumber  = '12A3B4C56B12345A6BC'
     }
    New-UMSThinclient @NewUMSThinclientParams

## Restart-UMSThinclient
Restarts Thinclients via API

**Restarts thin client with TCID 2433**
    
    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    Restart-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
      
**Restarts thin clients with TCID 2433 and 2435**      
      
    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    2433, 2435 | Restart-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession
      
## Start-UMSThinclient
Wakes Up Thinclients (WOL) via API

**Wakes up thin client with TCID 2433**

    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    Start-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
     
**Wakes up thin clients with TCID 2433 and 2435**

    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    2433, 2435 | Start-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession

## Stop-UMSThinclient
Shuts Down Thinclients via API

**Shuts down thin client with TCID 2433**

    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    Stop-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
      
**Shuts down thin clients with TCID 2433 and 2435**   
 
    $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
    2433, 2435 | Stop-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession
      
## Get-UMSDirectory
Gets Directory from UMS-DB

**Get all Directories**
      
    Get-UMSDirectory -ServerInstance 'SQLSERVER\RMDB'

**Get Directory with DIRID**

    Get-UMSDirectory -ServerInstance 'SQLSERVER\RMDB' -DIRIDColl 34858

**Get Directories with DIRID "34858" and "34859"**
    
    34858, 34859 | Get-UMSDirectory -ServerInstance 'SQLSERVER\RMDB'

## Get-UMSDirectoryStructure
Gets Thinclient Directory Structure from UMS-DB

**Get Directory Structure and outputs it to Gridview (ISE only)**

    Get-UMSDirectoryStructure -ServerInstance 'SQLSERVER\RMDB' | Out-Gridview

![GetUMSDirectoryStructureOutGridview](/docs/images/GetUMSDirectoryStructureOutGridview.png)

**Get Directory Structure, Generates csv File, sorted and without Parenthesis , UTF8 stripped from BOM**

	$UMSDirectoryStructure = Get-UMSDirectoryStructure -ServerInstance 'SQLSERVER\RMDB' | 
		Select-Object -Property BaseDirName, OrgDirName, CampusDirName, RoomDirName |
		Sort-Object -Property BaseDirName, OrgDirName, CampusDirName, RoomDirName |
		ConvertTo-Csv -Delimiter ';' -NoTypeInformation |
		ForEach-Object {
			$_ -replace "`"", ''
		}
	[IO.File]::WriteAllLines(('{0}\UMSDirectories.csv' -f $env:TMP), $UMSDirectoryStructure)
  
*UMSDirectories.csv:*
  
    BaseDirName;OrgDirName;CampusDirName;RoomDirName
    UDC3;A_Computers;A_CP_H1;A_RA_2001
    UDC3;A_Computers;A_CP_H1;A_RA_2002
    UDC3;A_Computers;A_CP_H1;A_RA_2003
    UDC3;A_Computers;A_CP_H1;A_RA_2004
    UDC3;A_Computers;A_CP_H1;A_RA_2005
    UDC3;A_Computers;A_CP_H1;A_RA_2017
    UDC3;A_Computers;A_CP_H1;A_RA_2018
    UDC3;A_Computers;A_CP_H1;A_RA_2019
    ...

## Get-UMSJob
Gets Job from UMS-DB

**Get all jobs**

    Get-UMSJob -ServerInstance 'SQLSERVER\RMDB'

Get Job with JobID "513333"

    Get-UMSJob -ServerInstance 'SQLSERVER\RMDB' -JobIDColl 513339

Get Jobs with JobID "513934" and "513333" 

    515266, 513339 | Get-UMSJob -ServerInstance 'SQLSERVER\RMDB'
  
## Get-UMSThinclientToUpdate
Get thinclients from UMS-DB which have a lower firmware-version than their respective associated (direct or per directory) Update-Profile or Universal Firmware Update. Select those which reported to UMS in specified time, given total and / or per Directory number AND are online (Ping).
Other than the associated Universal Firmware Update, the Update Profiles in use for Updates (System -> Updates -> Firmwareupdate / Buddy Update) must have the provided Firmwareversion in their Profilename recognizable per regex word boundaries (e.g. "07|Update_FirmwareUpdate_V4_10.10.1.1_FTP|4.14.300|UDLXV4").
Please ensure, that associated Update-Profiles are used rational, since concurrent profiles are not evaluated (e.g two associated profiles with different higher firmware versions).

**Get all Thinclients to be updated**

    Get-UMSThinclientToUpdate -ServerInstance 'SQLSERVER\RMDB'

**Get a total of 10 Thinclients, max. 2 per Directory to be updated, outputs it to Gridview (ISE only)**

    Get-UMSThinclientToUpdate -ServerInstance 'SQLSERVER\RMDB' -NumberTotal 10 -NumberPerDirName 2 | Out-GridView

![GetUMSThinclientToUpdateGridview](/docs/images/GetUMSThinclientToUpdateGridview.png)

## Get-UMSThinclientWithComment
Get Thinclient with Comment from UMS-DB

**Get Thinclients with Comment "Update"**

    Get-UMSThinclientWithComment -ServerInstance 'SQLSERVER\RMDB' -Comment Update
    
**or**    
    
    'Comment' | Get-UMSThinclientWithComment -ServerInstance 'SQLSERVER\RMDB'

## Get-UMSView
Get View from UMS-DB

**Get all Views**

    Get-UMSView -ServerInstance 'SQLSERVER\RMDB
    
**Get View with ViewID "525870"**

    Get-UMSView -ServerInstance 'SQLSERVER\RMDB' -ViewIDColl 525870

**Get Views with ViewID "513934" and "513333"**

    513934, 513333 | Get-UMSView -ServerInstance 'SQLSERVER\RMDB'
    
## Update-UMSJobStartDate
Update Job Startdate in UMS-DB

**Update Job Startdate on Job with ID 607377**

    Update-UMSJobStartDate -ServerInstance 'SQLSERVER\RMDB' -JobIDColl 513339 -Startdate '2018-01-10 14:47:00'
    
**Update Job Startdate on Jobs with ID "607377" and "680819"**

    513339,515266 | Update-UMSJobStartDate -ServerInstance 'SQLSERVER\RMDB' -Startdate '2018-01-10 14:47:00'

## Update-UMSThinclientComment
Set Comment on Thinclient in UMS-DB

**Set Comment "Comment" on thinclient with TCID 607377**

    Update-UMSThinclientComment -ServerInstance 'SQLSERVER\RMDB' -TCIDColl 607377 -Comment Comment
    
**Set Comments "Comment" on thinclients with TCID 607377 and 680819**

    607377,680819 | Update-UMSThinclientComment -ServerInstance 'SQLSERVER\RMDB' -Comment Comment
    
**Removes Comments on thinclients with TCID 607377 and 680819**

    607377,680819 | Update-UMSThinclientComment -ServerInstance 'SQLSERVER\RMDB'
    
## Invoke-Sqlcmd2

used for SQL queries

from [RamblingCookieMonster](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1)

 > Runs a T-SQL script. Invoke-Sqlcmd2 runs the whole scipt and only captures the first selected result set, such as the output of PRINT statements when -verbose parameter is specified.
Paramaterized queries are supported.
