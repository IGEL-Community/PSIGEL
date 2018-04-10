# PSIGEL

This is a module to interact with the IGEL UMS API (via IGEL IMI) and/or MSSQL-Database.

The **API** uses a cookie as authentication. You can create it with [New-UMSAPICookie](#new-umsapicookie). In the examples below it is assumed that you have created it as **$Websession** :
```
$Websession = New-UMSAPICookie -Computername UMSSERVER -TCPPort 8443 -Username igelums -ApiVersion 3
```

To connect to the **MSSQL** Database it may be required to provide credentials. In the examples below it is assumed that you have created it as **$Credential** :

```
$Credential = Get-Credential -Message 'Enter your credentials'
```

My goal is to support all the [API-functionalities](http://edocs.igel.com/manuals/en/en_imi_ref/index.htm#14276.htm) and to combine them were possible with MSSQL-Queries in to one function. If there is only a MSSQL-Query to provide a functionality, than there will be a MSSQL-only function (suggestions are welcome).

## API + MSSQL

  * [Get-UMSThinclient](#get-umsthinclient)

## API

  * [Get-UMSFirmware](#get-umsfirmware)
  * [Get-UMSProfile](#get-umsprofile)
  * [Get-UMSProfileAssignment](#get-umsprofileassignment)
  * [Get-UMSThinclientAssignment](#get-umsthinclientassignment)
  * [Get-UMSStatus](#get-umsstatus)
  * [New-UMSAPICookie](#new-umsapicookie)
  * [New-UMSThinclient](#new-umsthinclient)
  * [Remove-UMSProfile](#remove-umsprofile)
  * [Remove-UMSProfileAssignment](#remove-umsprofileassignment)
  * [Remove-UMSThinclient](#remove-umsthinclient)
  * [Reset-UMSThinclient](#reset-umsthinclient)
  * [Restart-UMSThinclient](#restart-umsthinclient)
  * [Send-UMSThinclientSettings](#send-umsthinclientsettings)
  * [Start-UMSThinclient](#start-umsthinclient)
  * [Stop-UMSThinclient](#stop-umsthinclient)
  * [Update-UMSProfileAssignment](#update-umsprofileAssignment)
  * [Update-UMSProfileName](#update-umsprofilename)
  * [Update-UMSThinclient](#update-umsthinclient)

## MSSQL

  * [Get-UMSDirectory](#get-umsdirectory)
  * [Get-UMSDirectoryStructure](#get-umsdirectorystructure)
  * [Get-UMSJob](#get-umsjob)
  * [Get-UMSThinclientToUpdate](#get-umsthinclienttoupdate)
  * [Get-UMSThinclientWithComment](#get-umsthinclientwithcomment)
  * [Get-UMSView](#get-umsview)
  * [Invoke-UMSThinclientUpdate](#invoke-umsthinclientupdate)
  * [Update-UMSJobStartDate](#update-umsjobstartdate)
  * [Update-UMSThinclientComment](#update-umsthinclientcomment)

## Other

  * [Invoke-Sqlcmd2](#invoke-sqlcmd2)

### Get-UMSFirmware
Gets information on all firmwares known to the UMS

**Gets information on all firmwares known to the UMS to Out-Gridview**
```
Get-UMSFirmware -Computername 'UMSSERVER' -WebSession $WebSession | Out-Gridview
```

**Gets information on firmwares with FirmwareIDs 9 and 7**
```
9, 7 | Get-UMSFirmware -Computername 'UMSSERVER' -WebSession $WebSession
```

### Get-UMSDirectory
Gets Directory from UMS-DB

**Get all Directories**
      
```
Get-UMSDirectory -ServerInstance 'SQLSERVER\RMDB'
```

**Get Directory with DIRID**

```
Get-UMSDirectory -ServerInstance 'SQLSERVER\RMDB' -DIRIDColl 34858
```

**Get Directories with DIRID "34858" and "34859"**
    
```
34858, 34859 | Get-UMSDirectory -ServerInstance 'SQLSERVER\RMDB'
```

### Get-UMSDirectoryStructure
Gets Thinclient Directory Structure from UMS-DB

**Get Directory Structure and outputs it to Gridview (ISE only)**

```
Get-UMSDirectoryStructure -ServerInstance 'SQLSERVER\RMDB' | Out-Gridview
```

![GetUMSDirectoryStructureOutGridview](/docs/images/GetUMSDirectoryStructureOutGridview.png)

**Get Directory Structure, Generates csv File, sorted and without Parenthesis , UTF8 stripped from BOM**

```
$UMSDirectoryStructure = Get-UMSDirectoryStructure -ServerInstance 'SQLSERVER\RMDB' | 
	Select-Object -Property BaseDirName, OrgDirName, CampusDirName, RoomDirName |
	Sort-Object -Property BaseDirName, OrgDirName, CampusDirName, RoomDirName |
	ConvertTo-Csv -Delimiter ';' -NoTypeInformation |
	ForEach-Object {
		$_ -replace "`"", ''
	}
[IO.File]::WriteAllLines(('{0}\UMSDirectories.csv' -f $env:TMP), $UMSDirectoryStructure)
```
	
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

### Get-UMSJob
Gets Job from UMS-DB

**Get all jobs**

`Get-UMSJob -ServerInstance 'SQLSERVER\RMDB'`

Get Job with JobID "513333"

`Get-UMSJob -ServerInstance 'SQLSERVER\RMDB' -JobIDColl 513339`

Get Jobs with JobID "513934" and "513333" 

`515266, 513339 | Get-UMSJob -ServerInstance 'SQLSERVER\RMDB'`

### Get-UMSProfile
Gets information on profiles on the UMS instance.

**Gets information on all profiles on the UMS instance to Out-Gridview**

````
Get-UMSProfile -Computername 'UMSSERVER' -WebSession $WebSession | Out-Gridview
````

**Gets information on the profile with ProfileID 100**

````
100 | Get-UMSProfile -Computername 'UMSSERVER' -WebSession $WebSession
````     

### Get-UMSProfileAssignment
Gets the thinclients and directories the profile is assigned to

**Gets the thin clients and the directories the profile with ProfileID 471 is assigned to**
```
Get-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 471
```
```
471 | Get-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession
```

### Get-UMSThinclientToUpdate
Get thinclients from UMS-DB which have a lower firmware-version than their respective associated (direct or per directory) Update-Profile or Universal Firmware Update. Select those which reported to UMS in specified time, given total and / or per Directory number AND are online (Ping).
Other than the associated Universal Firmware Update, the Update Profiles in use for Updates (System -> Updates -> Firmwareupdate / Buddy Update) must have the provided Firmwareversion in their Profilename recognizable per regex word boundaries (e.g. "07|Update_FirmwareUpdate_V4_10.10.1.1_FTP|4.14.300|UDLXV4").
Please ensure, that associated Update-Profiles are used rational, since concurrent profiles are not evaluated (e.g two associated profiles with different higher firmware versions).

**Get all Thinclients to be updated**

`Get-UMSThinclientToUpdate -ServerInstance 'SQLSERVER\RMDB'`

**Get a total of 10 Thinclients, max. 2 per Directory to be updated, outputs it to Gridview (ISE only)**

`Get-UMSThinclientToUpdate -ServerInstance 'SQLSERVER\RMDB' -NumberTotal 10 -NumberPerDirName 2 | Out-GridView`

![GetUMSThinclientToUpdateGridview](/docs/images/GetUMSThinclientToUpdateGridview.png)

### Get-UMSThinclient
Gets Thinclient from UMS API and/or MSSQL-Database

**Gets detailed information on all online thin clients**

```
Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Details 'full' | Out-GridView
```

**Gets short information on thin clients with TCID 2433**

```
Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
```

**Gets shadow-information on Thinclient with TCID 2433**

```
2433 | Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Details 'shadow'
```

**Gets all Thinclients**
   
`Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' | Out-GridView`
      
**Asks for Credential and gets Thinclient with TCID 2433**
  
```  
Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -TCID 2433 -Credential $Credential
```
      
**Gets Thinclient with TCID 2433**
    
`433 | Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'`

### Get-UMSThinclientAssignment
Gets the profile and master profile assignments for the specified thin client, in order of their application from Rest API.

**Gets the profile and master profile assignments for Thinclient with TCID 243**

```
Get-UMSThinclientAssignment -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433 | Out-GridView
```

**Gets the profile and master profile assignments for Thinclient with TCID 2433**

```
2433 | Get-UMSThinclientAssignment -Computername 'UMSSERVER' -WebSession $WebSession
```

### Get-UMSThinclientWithComment
Get Thinclient with Comment from UMS-DB

**Get Thinclients with Comment "Update"**

`Get-UMSThinclientWithComment -ServerInstance 'SQLSERVER\RMDB' -Comment Update`
    
**or**    
    
`'Comment' | Get-UMSThinclientWithComment -ServerInstance 'SQLSERVER\RMDB'`

### Get-UMSStatus
Gets diagnostic information about the UMS instance

```
Get-UMSStatus -Computername 'UMSSERVER' -WebSession $WebSession
```

Output:

    rmGuiServerVersion : 5.08.100
    buildNumber        : 33604
    activeMQVersion    : 5.6.0
    derbyVersion       : 10.12.1.1
    serverUUID         : 482dc573-49d2-44dc-2565-c1471c598434
    server             : UMSSERVER.domain.com:8443
    links              : {}

### Get-UMSView
Get View from UMS-DB

**Get all Views**

`Get-UMSView -ServerInstance 'SQLSERVER\RMDB`
    
**Get View with ViewID "525870"**

`Get-UMSView -ServerInstance 'SQLSERVER\RMDB' -ViewIDColl 525870`

**Get Views with ViewID "513934" and "513333"**

`513934, 513333 | Get-UMSView -ServerInstance 'SQLSERVER\RMDB'`

### Invoke-UMSThinclientUpdate
[automates specific Thinclient Update mechanism](/docs/InvokeUMSThinclientUpdate.md)

### New-UMSAPICookie
Creates Websession Cookie for IGEL UMS API

**Asks for Password and creates Cookie-Object for use in API-Functions**

`New-UMSAPICookie -Computername UMSSERVER -TCPPort 8443 -Username igelums -ApiVersion 3`
 
 ### New-UMSThinclient
Creates a new thinclient from Rest API

**Creates new thinclient with mac and firmwareid (minimal requirements) in the root directory**

```
New-UMSThinclient -Computername $Computername -WebSession $WebSession -Mac 012345678910 -FirmwareID 9
```

**Creates new thinclient with all possible attributes**

```
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
```

### Remove-UMSProfile
Deletes profile

**Removes Profile with ProfileID 100**
```
Remove-UMSProfile -Computername $Computername -WebSession $WebSession -ProfileID 100
```     
```  
100 | Remove-UMSProfile -Computername $Computername -WebSession $WebSession
```

### Remove-UMSProfileAssignment
Deletes assignment of the specified profile to the specified thin cient or thin client directory.

**Deletes assignment of profile with ProfileID 471 to the thin cient with the TCID 100**
```
Remove-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 471 -TCID 100
```      

**Deletes assignment of profile with ProfileID 471 to the thin cient directory with the DirID 300**
```
Remove-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 471 -DirID 300
```

### Remove-UMSThinclient 
Removes a thinclient from Rest API

**Removes Thinclient with TCID 100**
```
Remove-UMSThinclient -Computername $Computername -WebSession $WebSession -TCID 100
```

```   
100 | Remove-UMSThinclient -Computername $Computername -WebSession $WebSession
```  
### Reset-UMSThinclient
Resets all thin clients listed in the request body to factory defaults

**Resets thin client with TCID 100 to factory defaults**
```
Reset-UMSThinclient -Computername $Computername -WebSession $WebSession -TCID 100
```
      
**Resets thin clients with TCID 100 and 101 to factory defaults**
```
100, 101 | Reset-UMSThinclient -Computername $Computername -WebSession $WebSession
```      

### Restart-UMSThinclient
Restarts Thinclients via API

**Restarts thin client with TCID 2433**
    
```
Restart-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
```

**Restarts thin clients with TCID 2433 and 2435**      

```   
2433, 2435 | Restart-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession
```

### Send-UMSThinclientSettings
Sends settings modified in the UMS database to all thin clients listed in the request body immediately

**Sends settings modified in the UMS database to thin client with TCID 100 immediately**

```
Send-UMSThinclientSettings -Computername $Computername -WebSession $WebSession -TCID 100
```

**Sends settings modified in the UMS database to thin clients with TCID 100 and 101 immediately**
```
100, 101 | Send-UMSThinclientSettings -Computername $Computername -WebSession $WebSession
```

### Start-UMSThinclient
Wakes Up Thinclients (WOL) via API

**Wakes up thin client with TCID 2433**

```
Start-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
```
     
**Wakes up thin clients with TCID 2433 and 2435**

```
2433, 2435 | Start-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession
```

### Stop-UMSThinclient
Shuts Down Thinclients via API

**Shuts down thin client with TCID 2433**

```
Stop-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
```
      
**Shuts down thin clients with TCID 2433 and 2435**   

```
2433, 2435 | Stop-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession
```

### Update-UMSJobStartDate
Update Job Startdate in UMS-DB

**Update Job Startdate on Job with ID 607377**

`Update-UMSJobStartDate -ServerInstance 'SQLSERVER\RMDB' -JobIDColl 513339 -Startdate '2018-01-10 14:47:00'`
    
**Update Job Startdate on Jobs with ID "607377" and "680819"**

`513339,515266 | Update-UMSJobStartDate -ServerInstance 'SQLSERVER\RMDB' -Startdate '2018-01-10 14:47:00'`

### Update-UMSProfileAssignment
Assigns a profile to a thin clients or a thin client directory

**Assigns the profile with ProfilID 471 to thin client with TCID 100**
```
Update-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 471 -TCIDColl (100, 102)
```

**Assigns the profile with ProfilID 471 to thin client directory with DirID 300**
```
Update-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 471 -DirIDColl 300
```


### Update-UMSProfileName
Updates a profile name

**Updates profile name to 'NewProfileName'**

```
Update-UMSProfileName -Computername $Computername -WebSession $WebSession -ProfileID 100 -Name 'NewProfileName'
```      

**Updates profile name to 'NewProfileName'**

```
$UpdateUMSProfileNameParams = @{
    Computername  = 'UMSSERVER'
    WebSession    = $WebSession
    ProfileID     = 100
    Name          = 'NewProfileName'
  }
Update-UMSProfileName @UpdateUMSProfileNameParams
```

### Update-UMSThinclient
Updates a thinclient from Rest API

**Updates site of the thinclient to Berlin**

```
Update-UMSThinclient -Computername $Computername -WebSession $WebSession -TCID 100 -Site 'Berlin'
```

**Updates thinclient with all possible attributes**     
      
```
$UpdateUMSThinclientParams = @{
    Computername  = 'UMSSERVER'
    WebSession    = $WebSession
    TCID          = 100
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
Update-UMSThinclient @UpdateUMSThinclientParams
```

### Update-UMSThinclientComment
Set Comment on Thinclient in UMS-DB

**Set Comment "Comment" on thinclient with TCID 607377**

`Update-UMSThinclientComment -ServerInstance 'SQLSERVER\RMDB' -TCIDColl 607377 -Comment Comment`
    
**Set Comments "Comment" on thinclients with TCID 607377 and 680819**

`607377,680819 | Update-UMSThinclientComment -ServerInstance 'SQLSERVER\RMDB' -Comment Comment`
    
**Removes Comments on thinclients with TCID 607377 and 680819**

`607377,680819 | Update-UMSThinclientComment -ServerInstance 'SQLSERVER\RMDB'`
    
### Invoke-Sqlcmd2

used for SQL queries

from [RamblingCookieMonster](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1)

 > Runs a T-SQL script. Invoke-Sqlcmd2 runs the whole scipt and only captures the first selected result set, such as the output of PRINT statements when -verbose parameter is specified.
Paramaterized queries are supported.
