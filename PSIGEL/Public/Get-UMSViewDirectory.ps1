function Get-UMSViewDirectory
{
  <#
      .Synopsis
      Gets View Directories from UMS-DB

      .DESCRIPTION
      Gets View Directories from UMS-DB

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
      Get-UMSViewDirectory -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -Credential $Credential
      #Gets all View Directories

      .EXAMPLE
      557 | Get-UMSViewDirectory -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      #Gets View Directories with DirID "557"
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
    $InvokeSqlcmd2Params = @{
      ServerInstance = $ServerInstance
      Database       = $Database
    }

    if ($null -ne $Credential)
    {
      $InvokeSqlcmd2Params.Credential = $Credential
    }

    $BaseQuery = (@'
SELECT *
FROM [{0}].[{1}].[TCVIEWDIRECTORIES]
'@ -f $Database, $Schema)
    if (!$DirID)
    {
      $Query = $BaseQuery
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
    else
    {
      $Query = ((@"
  WHERE [{0}].[{1}].[TCVIEWDIRECTORIES].[DIRID] = '{2}'
"@ -f $Database, $Schema, $DirID))
      $Query = ($BaseQuery, $Query -join "`n")
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
  }
  End
  {
  }
}