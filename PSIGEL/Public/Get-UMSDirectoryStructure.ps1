function Get-UMSDirectoryStructure
{
	<#
			.Synopsis
			Gets Thinclient Directory Structure from UMS-DB
			.DESCRIPTION
			Gets Thinclient Directory Structure from UMS-DB
			.EXAMPLE
			Get-UMSDirectoryStructure -ServerInstance 'SQLSERVER\RMDB' | Out-Gridview
			.EXAMPLE
			$UMSDirectoryStructure = Get-UMSDirectoryStructure -ServerInstance 'SQLSERVER\RMDB' | 
				Select-Object -Property BaseDirName, OrgDirName, CampusDirName, RoomDirName |
				Sort-Object -Property BaseDirName, OrgDirName, CampusDirName, RoomDirName |
				ConvertTo-Csv -Delimiter ';' -NoTypeInformation |
				ForEach-Object {
					$_ -replace "`"", ''
				}
			[IO.File]::WriteAllLines(('{0}\UMSDirectories.csv' -f $env:TMP), $GetUMSDirectories)
			Generates csv File, sorted and without Parenthesis , UTF8 stripped from BOM
	#>
	
	Param
	(
		[Parameter(Mandatory)]
		[String]
		$ServerInstance
	)


		$Query = @'
SELECT [DIRID]
,[NAME]
,[MEMBEROF]
FROM [rmdb].[igelums].[DIRECTORIES]
'@

	$DirColl = Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
	$BaseDirColl = $DirColl | Where-Object {$_.MemberOf -notmatch '\d+'}
	$UMSDirectoryStructure = foreach ($BaseDir in $BaseDirColl)
	{
		$OrgDirColl = $DirColl | Where-Object {$_.MemberOf -eq $BaseDir.DIRID}
		foreach ($OrgDir in $OrgDirColl)
		{
			$CampusDirColl = $DirColl | Where-Object {$_.MemberOf -eq $OrgDir.DIRID}
			foreach ($CampusDir in $CampusDirColl)
			{
				$RoomDirColl = $DirColl | Where-Object {$_.MemberOf -eq $CampusDir.DIRID}
				foreach ($RoomDir in $RoomDirColl)
				{
					$UMSDirectoriesProps = @{
						BaseDirName = $BaseDir.Name
						BaseDirId = $BaseDir.DIRID
						OrgDirName = $OrgDir.Name
						OrgDirId = $OrgDir.DIRID
						CampusDirName = $CampusDir.Name
						CampusDirId = $CampusDir.DIRID
						RoomDirName  = $RoomDir.Name
						RoomDirId  = $RoomDir.DIRID
					}
					New-Object -TypeName PSObject -Property $UMSDirectoriesProps
				}
			}
		}
	}
	$UMSDirectoryStructure
}