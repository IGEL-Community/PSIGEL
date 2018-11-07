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
      If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the
      Windows account running the PowerShell session.

      .PARAMETER FileID
      FileIDs to search for

      .EXAMPLE
      $Params = @{
        Credential     = Get-Credential
        ServerInstance = 'SQLSERVER\RMDB'
        Database       = 'RMDB'
        Schema         = 'igelums'
      }
      Get-UMSFile @Params
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
    $InvokeSqlcmd2Params = @{
      ServerInstance = $ServerInstance
      Database       = $Database
    }

    if ($null -ne $Credential)
    {
      $InvokeSqlcmd2Params.Credential = $Credential
    }

    $BaseQuery = (@'
SELECT [{0}].[{1}].[URLFILE].[FILEID] AS FILEID
      ,[{0}].[{1}].[URLFILE].[FILEURL] AS FILEURL
      ,[{0}].[{1}].[URLFILE].[TCURL] AS TCURL
      ,[{0}].[{1}].[URLFILE].[CLASSIFICATION] AS CLASSIFICATION
      ,[{0}].[{1}].[URLFILE].[MD5] AS MD5
      ,[{0}].[{1}].[URLFILE].[MD5Date] AS MD5Date
      ,[{0}].[{1}].[URLFILE].[USERNAME] AS USERNAME
      ,[{0}].[{1}].[URLFILE].[PASSWORD] AS PASSWORD
      ,[{0}].[{1}].[URLFILE].[OWNER] AS OWNER
      ,[{0}].[{1}].[URLFILE].[PERMISSION] AS PERMISSION
      ,[{0}].[{1}].[URLFILE].[FILE_HIDDEN] AS FILE_HIDDEN
      ,[{0}].[{1}].[URLFILE].[MOVEDTOBIN] AS MOVEDTOBIN
      ,[{0}].[{1}].[URLFILESTOREDIN].[DIRID] AS DIRID
  FROM [{0}].[{1}].[URLFILE]
  LEFT JOIN [{0}].[{1}].[URLFILESTOREDIN]
  ON [{0}].[{1}].[URLFILE].[FILEID] = [{0}].[{1}].[URLFILESTOREDIN].[FILEID]
'@ -f $Database, $Schema)
    if (!$FileID)
    {
      $Query = $BaseQuery
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
    else
    {
      $Query = ((@"
  WHERE [{0}].[{1}].[URLFILE].[FILEID] = '{2}'
"@ -f $Database, $Schema, $FileID))
      $Query = ($BaseQuery, $Query -join "`n")
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
  }
  End
  {
  }
}