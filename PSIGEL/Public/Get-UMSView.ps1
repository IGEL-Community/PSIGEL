function Get-UMSView
{
  <#
      .Synopsis
      Gets View from UMS-DB

      .DESCRIPTION
      Gets View from UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER Database
      SQL Database  for the UMS-DB (e.g. 'RMDB')

      .PARAMETER Schema
      SQL Schema  for the UMS-DB (e.g. 'igelums')

      .PARAMETER Credential
      Specifies A PSCredential for SQL Server Authentication connection to an instance of the Database Engine.
      If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the Windows account running the PowerShell session.

      .PARAMETER ViewIDColl
      ViewIDs to search for

      .EXAMPLE
      $Credential = Get-Credential
      Get-UMSView -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -Credential $Credential -ViewIDColl 558
      #Gets View with ViewID "558"

      .EXAMPLE
      558, 560 | Get-UMSView -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      #Gets Views with ViewID "558" and "560"
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
    [int[]]
    $ViewIDColl
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
    if (!$ViewIDColl)
    {
      $Query = (@'
SELECT *
FROM [{0}].[{1}].[TCVIEWS]
'@ -f $Database, $Schema)
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
    else
    {
      Foreach ($ViewID in $ViewIDColl)
      {
        $Query = ((@"
SELECT *
FROM [{0}].[{1}].[TCVIEWS]
WHERE VIEWID = '{2}'
"@ -f $Database, $Schema, $ViewID))
        Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
        #>
      }
    }
  }
  End
  {
  }
}

