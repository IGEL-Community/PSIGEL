function Get-UMSView
{
  <#
      .Synopsis
      Gets View from UMS-DB

      .DESCRIPTION
      Gets View from UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER ViewIDColl
      ViewIDs to search for

      .EXAMPLE
      Get-UMSView -ServerInstance 'SQLSERVER\RMDB'
      Gets all Views
      
      .EXAMPLE
      Get-UMSView -ServerInstance 'SQLSERVER\RMDB' -ViewIDColl 525870
      Gets Views with ViewID "525870"
      
      .EXAMPLE
      513934, 513333 | Get-UMSView -ServerInstance 'SQLSERVER\RMDB'
      Gets Views with ViewID "513934" and "513333" 
  #>
  
  [cmdletbinding()]
  param
  ( 
    [Parameter(Mandatory)]
    [String]
    $ServerInstance,
    
    [Parameter(ValueFromPipeline)]
    [int]
    $ViewIDColl = 0
  )
	
  Begin
  {
  }
  Process
  {
    switch ($ViewIDColl)
    {
      0
      {   
        $Query = @'
SELECT *
FROM [rmdb].[igelums].[TCVIEWS]
WHERE MOVEDTOBIN IS NULL
'@
        Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
      }
      default
      {
        Foreach ($ViewID in $ViewIDColl)
        {
          $Query = (@"
SELECT *
FROM [rmdb].[igelums].[TCVIEWS]
WHERE VIEWID = '{0}'
AND MOVEDTOBIN IS NULL
"@ -f $ViewID)
          Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
        }
      }
    }
    
  }
  End
  {
  }
}

