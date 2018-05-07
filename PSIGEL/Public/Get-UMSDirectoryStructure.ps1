function Get-UMSDirectoryStructure
{
  <#
      .Synopsis
      Gets Thinclient Directory Structure from MSSQL

      .DESCRIPTION
      Gets Thinclient Directory Structure from MSSQL. Expects 4 Tier-Directory Structure (e.g. Base / Organisation / Campus / Room)	

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER Database
      SQL Database  for the UMS-DB (e.g. 'RMDB')

      .PARAMETER Schema
      SQL Schema  for the UMS-DB (e.g. 'igelums')

      .PARAMETER Credential
      Specifies A PSCredential for SQL Server Authentication connection to an instance of the Database Engine.
      If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the Windows account running the PowerShell session.

      .EXAMPLE
      Get-UMSDirectoryStructure -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' | Out-Gridview

      .EXAMPLE
      $GetUMSDirectoryStructureParams = @{
          ServerInstance = 'SQLSERVER\RMDB'
          Database       = 'RMDB'
          Schema         = 'igelums'
          Credential     = Get-Credential -Message 'Enter your credentials'
        }
      $UMSDirectoryStructure = Get-UMSDirectoryStructure @GetUMSDirectoryStructureParams | 
        Select-Object -Property Tier1Name, Tier2Name, Tier3Name, Tier4Name |
        Sort-Object -Property Tier1Name, Tier2Name, Tier3Name, Tier4Name |
        ConvertTo-Csv -Delimiter ';' -NoTypeInformation |
        ForEach-Object {
        $_ -replace "`"", ''
        }
      [IO.File]::WriteAllLines(('{0}\UMSDirectories.csv' -f $env:TMP), $UMSDirectoryStructure)
      Generates csv File, sorted and without Parenthesis , UTF8 stripped from BOM
  #>
	
  Param
  (
    [Parameter(Mandatory)]
    [String]
    $ServerInstance,
    
    [Parameter(Mandatory)]
    [String]
    $Database,
    
    [Parameter(Mandatory)]
    [String]
    $Schema,

    [PSCredential]
    $Credential
  )


  $Query = @"
SELECT [DIRID]
,[NAME]
,[MEMBEROF]
FROM [$Database].[$Schema].[DIRECTORIES]
"@

  if ($Credential)
  {
    $InvokeSqlcmd2Params = @{
      ServerInstance = $ServerInstance
      Database       = $Database
      Credential     = $Credential
      Query          = $Query
    }
  }
  else
  {
    $InvokeSqlcmd2Params = @{
      ServerInstance = $ServerInstance
      Database       = $Database
      Query          = $Query
    }
  }

  $DirColl = Invoke-Sqlcmd2 @InvokeSqlcmd2Params
  $Tier1Coll = $DirColl | Where-Object {
    $_.MemberOf -notmatch '\d+'
  }
  $UMSDirectoryStructure = foreach ($Tier1 in $Tier1Coll)
  {
    $Tier2Coll = $DirColl | Where-Object {
      $_.MemberOf -eq $Tier1.DIRID
    }
    foreach ($Tier2 in $Tier2Coll)
    {
      $Tier3Coll = $DirColl | Where-Object {
        $_.MemberOf -eq $Tier2.DIRID
      }
      foreach ($Tier3 in $Tier3Coll)
      {
        $Tier4Coll = $DirColl | Where-Object {
          $_.MemberOf -eq $Tier3.DIRID
        }
        foreach ($Tier4 in $Tier4Coll)
        {
          $UMSDirectoriesProps = @{
            Tier1Name = $Tier1.Name
            Tier1Id   = $Tier1.DIRID
            Tier2Name = $Tier2.Name
            Tier2Id   = $Tier2.DIRID
            Tier3Name = $Tier3.Name
            Tier3Id   = $Tier3.DIRID
            Tier4Name = $Tier4.Name
            Tier4Id   = $Tier4.DIRID
          }
          New-Object -TypeName PSObject -Property $UMSDirectoriesProps
        }
      }
    }
  }
  $UMSDirectoryStructure
}
