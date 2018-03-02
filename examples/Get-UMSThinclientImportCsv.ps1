$ServerInstance = 'SRVSQL03\RMDB'

$UMSDirectoryStructure = Get-UMSDirectoryStructure -ServerInstance $ServerInstance
$UMSThinclient = Get-UMSThinclient -ServerInstance $ServerInstance

$JoinedTcDirCollParams = @{
	Left              = $UMSDirectoryStructure
	LeftJoinProperty  = 'RoomDirId'
	Right             = $UMSThinclient
	RightJoinProperty = 'DIRID'
	LeftProperties    = 'OrgDirName', 'CampusDirName', 'RoomDirName'
	RightProperties   = 'UNIT_ID', 'MODELNAME', 'VERSION', 'TCNAME', 'SITE', 'DEPARTMENT', 'TCCOMMENT', 'ASSETID', 'INSERVICEDATE', 'SERIALNUMBER'
	Type              = 'AllInRight'
}

$JoinedTcDirColl = Join-Object @JoinedTcDirCollParams |
Sort-Object -Property OrgDirName, CampusDirName, RoomDirName, TCNAME |
Select-Object -Property @{
	Name       = 'Directory'
	Expression = {
		if ($_.OrgDirName -and  $_.CampusDirName-and $_.RoomDirName)
		{
			('/UDLX/{0}/{1}/{2}' -f $_.OrgDirName, $_.CampusDirName, $_.RoomDirName)
		}		
		elseif ($_.OrgDirName -and $_.CampusDirName)
		{
			('/UDLX/{0}/{1}' -f $_.OrgDirName, $_.CampusDirName)
		}		
		elseif ($_.OrgDirName)
		{
			('/UDLX/{0}' -f $_.OrgDirName)
		}
		else
		{
			('/UDLX')
		}
	}
}, UNIT_ID, MODELNAME, VERSION, TCNAME, SITE, DEPARTMENT, TCCOMMENT, ASSETID, INSERVICEDATE, SERIALNUMBER |
ConvertTo-Csv -Delimiter ';' -NoTypeInformation |
Select-Object -Skip 1 |
ForEach-Object {
	$_ -replace "`"", ''
}
[IO.File]::WriteAllLines(('{0}\UMSThinclientImport.csv' -f $env:TMP), $JoinedTcDirColl)
