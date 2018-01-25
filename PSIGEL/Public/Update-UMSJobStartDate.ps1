function Update-UMSJobStartDate
{
  <#
      .Synopsis
      Update Job Startdate in UMS-DB

      .DESCRIPTION
      Update Job Startdate in UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER JobIDColl
      Array of Job IDs

      .PARAMETER Startdate
      Startdate to set in Format 'yyyy-MM-dd 00:00:00'

      .EXAMPLE
      Update-UMSJobStartDate -ServerInstance 'SQLSERVER\RMDB' -JobIDColl 513339 -Startdate '2018-01-10 14:47:00'
      Update Job Startdate on Job with ID "607377"

      .EXAMPLE
      513339,515266 | Update-UMSJobStartDate -ServerInstance 'SQLSERVER\RMDB' -Startdate '2018-01-10 14:47:00'
      Update Job Startdate on Jobs with ID "607377" and "680819"
  #>
  
  [cmdletbinding()]
  param
  ( 
    [Parameter(Mandatory)]
    [String]
    $ServerInstance,
    
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
    foreach ($JobID in $JobIDColl)
    {
      $Query = (@"
UPDATE [rmdb].[igelums].[JOB] 
SET [STARTDATE] = '{0}'
WHERE [ID] = '{1}'
"@ -f $Startdate, $JobID)
      Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
    }

  }
  End
  {
  }

}

