function Get-UMSFile
{
  <#
      .Synopsis
      Gets File from UMS-DB

      .DESCRIPTION
      Gets File from UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER Database
      SQL Database for the UMS-DB (e.g. 'RMDB')

      .PARAMETER Schema
      SQL Schema for the UMS-DB (e.g. 'igelums')

      .PARAMETER Credential
      Specifies A PSCredential for SQL Server Authentication connection to an instance of the Database Engine.
      If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the Windows account running the PowerShell session.

      .PARAMETER FileIDColl
      FileIDs to search for

      .EXAMPLE
      $Credential = Get-Credential
      Get-UMSFile -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -Credential $Credential
      #Gets all Files

      .EXAMPLE
      653, 654 | Get-UMSFile -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      #Gets Files with FileID "653" and "654"
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
    $FileID
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
    if (!$FileID)
    {
      $Query = (@'
SELECT *
FROM [{0}].[{1}].[URLFILE]
'@ -f $Database, $Schema)
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
    else
    {
      $Query = ((@"
SELECT *
FROM [{0}].[{1}].[URLFILE]
WHERE FileID = '{2}'
"@ -f $Database, $Schema, $FileID))
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
  }
  End
  {
  }
}

