function Get-UMSJob
{
  <#
      .Synopsis
      Gets Job from UMS-DB

      .DESCRIPTION
      Gets Job from UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER')

      .PARAMETER JobIDColl
      JobIDs to search for

      .EXAMPLE
      Get-UMSJob -ServerInstance 'SQLSERVER\RMDB'
      Gets all Jobs
      
      .EXAMPLE
      Get-UMSJob -ServerInstance 'SQLSERVER\RMDB' -JobIDColl 513339
      Gets Job with JobID "513333"
      
      .EXAMPLE
      515266, 513339 | Get-UMSJob -ServerInstance 'SQLSERVER\RMDB'
      Gets Jobs with JobID "513934" and "513333" 
  #>
  
  [cmdletbinding()]
  param
  ( 
    [Parameter(Mandatory)]
    [String]
    $ServerInstance,
    
    [Parameter(ValueFromPipeline)]
    [int]
    $JobIDColl = 0
  )
	
  Begin
  {
  }
  Process
  {
    switch ($JobIDColl)
    {
      0
      {
        $Query = @'
SELECT *
FROM [rmdb].[igelums].[JOB]
WHERE MOVEDTOBIN IS NULL
'@
        Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
      }
      default
      {
        Foreach ($JobID in $JobIDColl)
        {
          $Query = (@"
SELECT *
FROM [rmdb].[igelums].[JOB]
WHERE ID = '{0}'
AND MOVEDTOBIN IS NULL
"@ -f $JobID)
          Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
        }
      }
    }
  }
  End
  {
  }
}

