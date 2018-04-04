function Get-UMSThinclient
{
  <#
      .Synopsis
      Gets Thinclient from UMS-DB

      .DESCRIPTION
      Gets Thinclient from UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER Database
      SQL Database  for the UMS-DB (e.g. 'RMDB')

      .PARAMETER DatabaseUser
      SQL DatabaseUser  for the UMS-DB (e.g. 'igelums')

      .PARAMETER TCIDColl
      ThinclientIDs to search for

      .EXAMPLE
      Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -DatabaseUser 'igelums' | Out-GridView
      Gets all Thinclients
      
      .EXAMPLE
      Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -DatabaseUser 'igelums' -TCIDColl 2433
      Gets Thinclient with TCID "607377"
      
      .EXAMPLE
      607377, 680819 | Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -DatabaseUser 'igelums'
      Gets Thinclient with TCID "607377" and "680819" 
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
    $DatabaseUser,
    
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
        $Query = @"
SELECT *
FROM [$Database].[$DatabaseUser].[THINCLIENT] TC, [$Database].[$DatabaseUser].[THINCLIENTISINDIRECTORY] TD, [$Database].[$DatabaseUser].[FIRMWARE] FW
WHERE TC.TCID = TD.TCID
AND TC.FIRMWAREID = FW.FIRMWAREID
AND MOVEDTOBIN IS NULL
"@
        Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Database $Database -Query $Query
      }
      default
      {
        Foreach ($TCID in $TCIDColl)
        {
          $Query = (@"
SELECT *
FROM [$Database].[$DatabaseUser].[THINCLIENT] TC, [$Database].[$DatabaseUser].[THINCLIENTISINDIRECTORY] TD, [$Database].[$DatabaseUser].[FIRMWARE] FW
WHERE TC.TCID = TD.TCID
AND TC.FIRMWAREID = FW.FIRMWAREID
AND TC.TCID = '{0}'
AND MOVEDTOBIN IS NULL
"@ -f $TCID)
          Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Database $Database -Query $Query
        }
      }
    }
  }
  End
  {
  }
}
