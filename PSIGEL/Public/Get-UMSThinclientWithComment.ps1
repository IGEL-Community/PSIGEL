function Get-UMSThinclientWithComment
{
  <#
      .Synopsis
      Gets Thinclient with Comment from UMS-DB

      .DESCRIPTION
      Gets Thinclient with Comment from UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER Comment
      Comment to search for

      .EXAMPLE
      Get-UMSThinclientWithComment -ServerInstance 'SQLSERVER\RMDB' -Comment Update
      Gets thinclients with Comment "Update"

      .EXAMPLE
      'Comment' | Get-UMSThinclientWithComment -ServerInstance 'SQLSERVER\RMDB'
      Gets thinclients with Comment "Comment"
  #>

  [cmdletbinding()]
  param
  (
    [Parameter(Mandatory)]
    [String]
    $ServerInstance,

    [Parameter(Mandatory, ValueFromPipeline)]
    [string]
    $Comment
  )

  Begin
  {
  }
  Process
  {
    $Query = (@"
SELECT [TCID]
FROM   [rmdb].[igelums].[THINCLIENT]
WHERE  [TCCOMMENT] = '{0}'
"@ -f $Comment)
    Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
  }
  End
  {
  }
}

