function Update-UMSJobStartDate
{
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

