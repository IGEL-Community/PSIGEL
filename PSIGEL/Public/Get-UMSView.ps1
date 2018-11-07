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

      .PARAMETER ViewID
      ViewIDs to search for

      .EXAMPLE
      $Credential = Get-Credential
      Get-UMSView -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -Credential $Credential
      #Gets all Views

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
    [int]
    $ViewID
  )

  Begin
  {
  }
  Process
  {
    if ($null -ne $Credential)
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
SELECT [{0}].[{1}].[TCVIEWS].[VIEWID] AS VIEWID
      ,[{0}].[{1}].[TCVIEWS].[VIEWNAME] AS VIEWNAME
      ,[{0}].[{1}].[TCVIEWS].[DESCRIPTION] AS DESCRIPTION
      ,[{0}].[{1}].[TCVIEWS].[TYPE] AS TYPE
      ,[{0}].[{1}].[TCVIEWS].[SCOPE] AS SCOPE
      ,[{0}].[{1}].[TCVIEWS].[USERNAME] AS USERNAME
      ,[{0}].[{1}].[TCVIEWS].[MOVEDTOBIN] AS MOVEDTOBIN
      ,[{0}].[{1}].[TCVIEWSTOREDIN].[DIRID] AS DIRID
  FROM [{0}].[{1}].[TCVIEWS]
  LEFT JOIN [{0}].[{1}].[TCVIEWSTOREDIN]
  ON [{0}].[{1}].[TCVIEWS].[VIEWID] = [{0}].[{1}].[TCVIEWSTOREDIN].[VIEWID]
'@ -f $Database, $Schema)

    if (!$ViewID)
    {
      $Query = $BaseQuery
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
    else
    {
      $Query = ((@"
  WHERE [{0}].[{1}].[TCVIEWS].[VIEWID] = '{2}'
"@ -f $Database, $Schema, $ViewID))
      $Query = ($BaseQuery, $Query -join "`n")
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
  }
  End
  {
  }
}