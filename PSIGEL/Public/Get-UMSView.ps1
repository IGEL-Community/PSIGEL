function Get-UMSView
{
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
    $InvokeSqlcmd2Params = @{
      ServerInstance = $ServerInstance
      Database       = $Database
    }

    if ($null -ne $Credential)
    {
      $InvokeSqlcmd2Params.Credential = $Credential
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