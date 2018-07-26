function Get-UMSJobDirectory
{
  <#
      .Synopsis
      Gets Job Directories from UMS-DB

      .DESCRIPTION
      Gets Job Directories from UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER Database
      SQL Database for the UMS-DB (e.g. 'RMDB')

      .PARAMETER Schema
      SQL Schema for the UMS-DB (e.g. 'igelums')

      .PARAMETER Credential
      Specifies A PSCredential for SQL Server Authentication connection to an instance of the Database Engine.
      If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the Windows account running the PowerShell session.

      .PARAMETER DirIDColl
      DirIDs to search for

      .EXAMPLE
      $Credential = Get-Credential
      Get-UMSJobDirectory -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -Credential $Credential
      #Gets all Job Directories

      .EXAMPLE
      557 | Get-UMSJobDirectory -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      #Gets Job Directories with DirID "557"
  #>

  [cmdletbinding()]
  param
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
    $Credential,

    [Parameter(ValueFromPipeline)]
    [int]
    $DirID
  )

  Begin
  {
  }
  Process
  {
    if ($Credential)
    {
      $InvokeSqlcmd2Params = @{
        ServerInstance = $ServerInstance
        Database       = $Database
        Credential     = $Credential
      }
    }
    else
    {
      $InvokeSqlcmd2Params = @{
        ServerInstance = $ServerInstance
        Database       = $Database
      }
    }
    $BaseQuery = (@'
SELECT *
FROM [{0}].[{1}].[JOBDIRECTORY]
'@ -f $Database, $Schema)
    if (!$DirID)
    {
      $Query = $BaseQuery
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
    else
    {
      $Query = ((@"
  WHERE [{0}].[{1}].[JOBDIRECTORY].[DIRID] = '{2}'
"@ -f $Database, $Schema, $DirID))
      $Query = ($BaseQuery, $Query -join "`n")
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
  }
  End
  {
  }
}