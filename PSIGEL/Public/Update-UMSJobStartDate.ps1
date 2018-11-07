function Update-UMSJobStartDate
{
  <#
      .Synopsis
      Update Job Startdate in UMS-DB

      .DESCRIPTION
      Update Job Startdate in UMS-DB

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
      Array of Job IDs

      .PARAMETER Startdate
      Startdate to set in Format 'yyyy-MM-dd 00:00:00'

      .EXAMPLE
      $Params = @{
        ServerInstance = 'SQLSERVER\RMDB'
        Database       = 'RMDB'
        Schema         = 'igelums'
        Credential     = (Get-Credential)
        JobIDColl      = 18701
        Startdate      = '2018-01-10 00:06:41'
      }
      Update-UMSJobStartDate @Params
      #Update Job Startdate on Job with ID "18701"

      .EXAMPLE
      18701,18706 | Update-UMSJobStartDate -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -Startdate '2018-01-10 14:47:00'
      #Update Job Startdate on Jobs with ID "18701" and "18706"
  #>

  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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

    [Parameter(Mandatory, ValueFromPipeline)]
    [int[]]
    $JobIDColl,

    [Parameter(Mandatory)]
    [datetime]
    $Startdate
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

    foreach ($JobID in $JobIDColl)
    {
      $Query = (@"
UPDATE [{0}].[{1}].[JOB]
SET [STARTDATE] = '{2}'
WHERE [ID] = '{3}'
"@ -f $Database, $Schema, $Startdate, $JobID)
    }
    if ($PSCmdlet.ShouldProcess('JobID: {0}' -f $JobID))
    {
      Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
    }
  }
  End
  {
  }

}

