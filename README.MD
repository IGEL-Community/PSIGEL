# PSIGEL

This is a module to interact with the IGEL UMS MSSQL-Database.

Most functions are wrappers for sql-queries. 

## Invoke-UMSThinclientUpdate
[automates specific Thinclient Update mechanism](/docs/InvokeUMSThinclientUpdate.md)

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

## Get-UMSThinclient
Gets Thinclient from UMS-DB

**Get all Thinclients**

    Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB'

**Get Thinclient with TCID "607377"**

    Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -TCIDColl 607377
    
**Get Thinclients with TCID "607377" and "680819"**
    
    607377, 680819 | Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB'
  
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
