function Get-UMSThinclientToUpdate
{
  <#
      .Synopsis
      Gets Thinclients which are configured to be updated

      .DESCRIPTION
      Gets thinclients from UMS-DB which have a lower firmware-version than their respective associated (direct or per directory)
      Update-Profile or Universal Firmware Update. Selects those which reported to UMS in specified time, given total and / or per
      Directory number AND online (Ping).
      See .NOTES for requirements!

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER NumberTotal
      [Default: 10] Total number of thinclients to select 
      
      .PARAMETER NumberPerDirName
      [Defalt: 2] Number of thinclients per UMS-Directory to select 
      
      .PARAMETER LogTime
      [Default: Today] Specifies the time since the thinclient reported last to the UMS in Format 'yyyy-MM-dd 00:00:00'

      .EXAMPLE
      Get-UMSThinclientToUpdate -ServerInstance 'SQLSERVER\RMDB'
      
      .EXAMPLE
      Get-UMSThinclientToUpdate -ServerInstance 'SQLSERVER\RMDB' -NumberTotal 10 -NumberPerDirName 2 | Out-GridView

      .NOTES
      Other than the associated Universal Firmware Update, the Update Profiles in use for Updates (System -> Updates -> Firmwareupdate / Buddy Update)
      must have the provided Firmwareversion in their Profilename recognizable per regex word boundaries (e.g. "07|Update_FirmwareUpdate_V4_10.10.1.1_FTP|4.14.300|UDLXV4").
      Please ensure, that associated Update-Profiles are used rational, since concurrent profiles are not evaluated (e.g two associated profiles with different higher 
      firmware versions).
  #>
  
  param
  ( 
    [Parameter(Mandatory)]
    [String]
    $ServerInstance,
    
    [int]
    $NumberTotal = 10,
    
    [int]
    $NumberPerDirName = 2,
    
    [datetime]
    $LogTime = (Get-Date -Format 'yyyy-MM-dd 00:00:00')
  )
	
  $Query = @'
DECLARE @TableTC TABLE([MACADDRESS] char(12)
						,[TCNAME] char (50)
						,[TCID] char (15)
						,[LASTKNOWNIP] char(15)
						,[LOGTIME] datetime 
						,[PRODUCTID] char (30)
						,[VERSION] char(15) 
						,[DIRID] char(12)
						,[DIRNAME] char (50)
						,[PARDIRID] char (12))
INSERT INTO @TableTC

SELECT  [MACADDRESS]
		,[TCNAME]
		,[THINCLIENT].[TCID]
		,[LASTKNOWNIP]
		,[LOGTIME]
		,[PRODUCTID]
		,[VERSION]
		,[THINCLIENTISINDIRECTORY].[DIRID]
		,[DIRECTORIES].[NAME]
		,[DIRECTORIES].[MEMBEROF]
FROM [rmdb].[igelums].[EVTHIS]
JOIN [rmdb].[igelums].[THINCLIENT]
ON EVTHIS.TCID = THINCLIENT.TCID
JOIN [rmdb].[igelums].[FIRMWARE]
ON THINCLIENT.FIRMWAREID = FIRMWARE.FIRMWAREID
JOIN [rmdb].[igelums].[THINCLIENTISINDIRECTORY]
ON THINCLIENT.TCID = THINCLIENTISINDIRECTORY.TCID
JOIN [rmdb].[igelums].[DIRECTORIES]
ON THINCLIENTISINDIRECTORY.DIRID = DIRECTORIES.DIRID
WHERE COMMAND = 'tc2server_de.igel.rm.rmserver.communication.tc2server.command.GetSettingsOnBoot_'

DECLARE @TableFWDIR TABLE([ID] char(15)
						,[VERSION] char (15)
						,[DIRID] char (15))
INSERT INTO @TableFWDIR

SELECT [FWU_FIRMWARES].[ID]
      ,[FWU_FIRMWARES].[VERSION]
	  ,[DIRECTORYHASFIRMWAREUPDATE].DIRID
FROM [rmdb].[igelums].[FWU_FIRMWARES], [rmdb].[igelums].[DIRECTORYHASFIRMWAREUPDATE]
WHERE [FWU_FIRMWARES].ID = [DIRECTORYHASFIRMWAREUPDATE].FIRMWAREUPDATEID

DECLARE @TableFWTC TABLE([ID] char(15)
						,[VERSION] char (15)
						,[TCID] char (15))
INSERT INTO @TableFWTC

SELECT [FWU_FIRMWARES].[ID]
      ,[FWU_FIRMWARES].[VERSION]
	  ,[FWUFIRMWARES_TC].TCID
FROM [rmdb].[igelums].[FWU_FIRMWARES], [rmdb].[igelums].[FWUFIRMWARES_TC]
WHERE [FWU_FIRMWARES].ID = [FWUFIRMWARES_TC].FIRMWAREUPDATEID

DECLARE @TablePROFDIR TABLE([ID] char(15)
						,[NAME] char (100)
						,[DIRID] char (15))

INSERT INTO @TablePROFDIR

SELECT [DIRECTORYHASPROFILE].[PROFILEID]  
	  ,[PROFILES].NAME
	  ,[DIRECTORYHASPROFILE].[DIRID]
  FROM [rmdb].[igelums].[DIRECTORYHASPROFILE], [rmdb].[igelums].[PROFILESETTINGS], [rmdb].[igelums].[PROFILES]
  WHERE [DIRECTORYHASPROFILE].[PROFILEID] = [PROFILESETTINGS].[PROFILEID]
  AND [PROFILES].PROFILEID = [DIRECTORYHASPROFILE].[PROFILEID]
  AND [PROFILES].MOVEDTOBIN IS NULL
  AND [PROFILESETTINGS].CLASSNAME = 'update.protocol'

(SELECT	 TC.[TCNAME]
		,TC.[TCID]
		,TC.[MACADDRESS]
		,TC.[LASTKNOWNIP]
		,TC.[LOGTIME]
		,TC.[PRODUCTID]
		,TC.[VERSION] AS HASVERSION
		,TC.[DIRNAME]
		,FWDIR.[VERSION] AS GETVERSION
		,FWDIR.[DIRID]

FROM @TableTC TC, @TableFWDIR FWDIR
WHERE TC.[PARDIRID] = FWDIR.[DIRID]
) 

UNION

(
SELECT	 TC.[TCNAME]
		,TC.[TCID]
		,TC.[MACADDRESS]
		,TC.[LASTKNOWNIP]
		,TC.[LOGTIME]
		,TC.[PRODUCTID]
		,TC.[VERSION] AS HASVERSION
		,TC.[DIRNAME]
		,FWTC.[VERSION] AS GETVERSION
		,FWTC.[TCID]

FROM @TableTC TC, @TableFWTC FWTC
WHERE TC.[TCID] = FWTC.[TCID]
)

UNION

(
SELECT	 TC.[TCNAME]
		,TC.[TCID]
		,TC.[MACADDRESS]
		,TC.[LASTKNOWNIP]
		,TC.[LOGTIME]
		,TC.[PRODUCTID]
		,TC.[VERSION] AS HASVERSION
		,TC.[DIRNAME]
		,PROFDIR.[NAME] AS GETVERSION
		,PROFDIR.[DIRID]

FROM @TableTC TC, @TablePROFDIR PROFDIR
WHERE TC.[PARDIRID] = PROFDIR.[DIRID]
)

'@

  $RegexVERSION = [regex] '\b([0-9]{1}\.[0-9]{2,2}.[0-9]{3,3})\b'
  $regexLASTKNOWNIP = [regex] '\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'

  $TCColl = Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query | 
  Where-Object -FilterScript {
    [datetime]$_.LOGTIME -ge $LogTime
  } |
  #all TCs which were online / logged with ums today
  Select-Object -Property TCNAME, TCID, MACADDRESS, LASTKNOWNIP, LOGTIME, PRODUCTID, @{
    Name       = 'HASVERSION'
    Expression = {
      (($RegexVERSION).Matches(($_.HASVERSION)) |
        ForEach-Object -Process {
          $_.value
      }) 
    }
  }, DIRNAME, @{
    Name       = 'GETVERSION'
    Expression = {
      (($RegexVERSION).Matches(($_.GETVERSION)) |
        ForEach-Object -Process {
          $_.value
      }) 
    }
  }, DIRID | 
  Where-Object -FilterScript {
    $_.HASVERSION -lt $_.GETVERSION
  }

  [int]$NumberTotalCount = 0
  $UMSThinclientToUpdate = foreach ($Dirname in ($TCColl.DIRNAME |
      Select-Object -Unique |
  Sort-Object))
  {
    $TCDirColl = $TCColl | Where-Object -FilterScript {
      $_.DIRNAME -eq $Dirname
    }
    [int]$NumberPerDirNameCount = 0
    foreach ($TCDir in $TCDirColl)
    {
      [int]$i = 0
      while (($NumberTotalCount -lt $NumberTotal) -and ($NumberPerDirNameCount -lt $NumberPerDirName) -and ($i -lt 1))
      { 
        $Address = (($RegexLASTKNOWNIP).Matches($TCDir.LASTKNOWNIP).Value)
        $StatusCode = (Get-WmiObject -Class Win32_PingStatus -Filter ('Address="{0}"' -f $Address)).StatusCode
      
        if ($StatusCode -eq 0)
        {
          $TCIDCollProps = @{
            'TCNAME' = $TCDir.TCNAME
            'TCID' = $TCDir.TCID
            'MACADDRESS' = $TCDir.MACADDRESS
            'LASTKNOWNIP' = $TCDir.LASTKNOWNIP
            'LOGTIME' = $TCDir.LOGTIME
            'PRODUCTID' = $TCDir.PRODUCTID
            'DIRNAME' = $TCDir.DIRNAME
            'DIRID' = $TCDir.DIRID
            'HASVERSION' = $TCDir.HASVERSION
            'GETVERSION' = $TCDir.GETVERSION
          }
          New-Object -TypeName psObject -Property $TCIDCollProps

        $NumberTotalCount++
        $NumberPerDirNameCount++
        }
        $i++
      }
    }
  }
  
  $UMSThinclientToUpdate
}

