function Get-UMSThinclient
{
  <#
      .Synopsis
      Gets Thinclient from UMS-DB

      .DESCRIPTION
      Gets Thinclient from UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER TCIDColl
      ThinclientIDs to search for

      .EXAMPLE
      Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' | Out-GridView
      Gets all Thinclients
      
      .EXAMPLE
      Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -TCIDColl 607377
      Gets Thinclient with TCID "607377"
      
      .EXAMPLE
      607377, 680819 | Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB'
      Gets Thinclient with TCID "607377" and "680819" 
  #>
  
  [cmdletbinding()]
  param
  ( 
    [Parameter(Mandatory)]
    [String]
    $ServerInstance,
    
    [Parameter(ValueFromPipeline)]
    [int]
    $TCIDColl = 0
  )
	
  Begin
  {
  }
  Process
  {
    switch ($TCIDColl)
    {
      0
      {
        $Query = @'
SELECT *
FROM [rmdb].[igelums].[THINCLIENT] TC, [rmdb].[igelums].[THINCLIENTISINDIRECTORY] TD, [rmdb].[igelums].[FIRMWARE] FW
WHERE TC.TCID = TD.TCID
AND TC.FIRMWAREID = FW.FIRMWAREID
AND MOVEDTOBIN IS NULL
'@
        Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
      }
      default
      {
        Foreach ($TCID in $TCIDColl)
        {
          $Query = (@"
SELECT *
FROM [rmdb].[igelums].[THINCLIENT] TC, [rmdb].[igelums].[THINCLIENTISINDIRECTORY] TD, [rmdb].[igelums].[FIRMWARE] FW
WHERE TC.TCID = TD.TCID
AND TC.FIRMWAREID = FW.FIRMWAREID
AND TC.TCID = '{0}'
AND MOVEDTOBIN IS NULL
"@ -f $TCID)
          Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
        }
      }
    }
  }
  End
  {
  }
}

