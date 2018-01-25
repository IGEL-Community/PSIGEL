function Get-UMSDirectory
{
  <#
      .Synopsis
      Gets Directory from UMS-DB

      .DESCRIPTION
      Gets Directory from UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER DIRIDColl
      DirIDs to search for

      .EXAMPLE
      Get-UMSDirectory -ServerInstance 'SQLSERVER\RMDB'
      Gets all Directories
      
      .EXAMPLE
      Get-UMSDirectory -ServerInstance 'SQLSERVER\RMDB' -DIRIDColl 34858
      Gets Directory with DIRID "34858"
      
      .EXAMPLE
      34858, 34859 | Get-UMSDirectory -ServerInstance 'SQLSERVER\RMDB'
      Gets Directories with DIRID "34858" and "34859" 
  #>
  
  [cmdletbinding()]
  param
  ( 
    [Parameter(Mandatory)]
    [String]
    $ServerInstance,
    
    [Parameter(ValueFromPipeline)]
    [int]
    $DIRIDColl = 0
  )
	
  Begin
  {
  }
  Process
  {
    switch ($DIRIDColl)
    {
      0
      {
        $Query = @'
SELECT *
FROM [rmdb].[igelums].[DIRECTORIES]
WHERE MOVEDTOBIN IS NULL
'@
        Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
      }
      default
      {
        Foreach ($DIRID in $DIRIDColl)
        {
          $Query = (@"
SELECT *
FROM [rmdb].[igelums].[DIRECTORIES]
WHERE DIRID = '{0}'
AND MOVEDTOBIN IS NULL
"@ -f $DIRID)
          Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
        }
      }
    }
  }
  End
  {
  }
}

