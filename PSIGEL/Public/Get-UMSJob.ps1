function Get-UMSJob
{
  <#
      .Synopsis
      Gets Job from UMS-DB

      .DESCRIPTION
      Gets Job from UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER Database
      SQL Database  for the UMS-DB (e.g. 'RMDB')

      .PARAMETER Schema
      SQL Schema  for the UMS-DB (e.g. 'igelums')

      .PARAMETER Credential
      Specifies A PSCredential for SQL Server Authentication connection to an instance of the Database Engine.
      If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the Windows account running the PowerShell session.

      .PARAMETER JobIDColl
      JobIDs to search for

      .EXAMPLE
      $Credential = Get-Credential
      Get-UMSJob -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -Credential $Credential -JobIDColl 732
      #Gets View with JobID "732"

      .EXAMPLE
      732, 734 | Get-UMSJob -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      #Gets Views with JobID "732" and "734"
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
    $JobIDColl
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
    if (!$JobIDColl)
    {
      $Query = (@'
SELECT *
FROM [{0}].[{1}].[JOB]
'@ -f $Database, $Schema)
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
    else
    {
      Foreach ($JobID in $JobIDColl)
      {
        $Query = ((@"
SELECT *
FROM [{0}].[{1}].[JOB]
WHERE ID = '{2}'
"@ -f $Database, $Schema, $JobID))
        Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
        #>
      }
    }
  }
  End
  {
  }
}

