function Update-UMSThinclientComment
{
  <#
      .Synopsis
      Sets Comment on Thinclient in UMS-DB

      .DESCRIPTION
      Sets Comment on Thinclient in UMS-DB

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER TCID
      Array of Thinclient ID (TCID)

      .PARAMETER Comment
      Comment to set

      .EXAMPLE
      Update-UMSThinclientComment -ServerInstance 'SQLSERVER\RMDB' -TCIDColl 607377 -Comment Comment
      Sets Comment "Comment" on thinclient with TCID 607377

      .EXAMPLE
      607377,680819 | Update-UMSThinclientComment -ServerInstance 'SQLSERVER\RMDB' -Comment Comment
      Sets Comment "Comment" on thinclients with TCID 607377 and 680819

      .EXAMPLE
      607377,680819 | Update-UMSThinclientComment -ServerInstance 'SQLSERVER\RMDB'
      Removes Comment
  #>

  [cmdletbinding()]
  param
  (
    [Parameter(Mandatory)]
    [String]
    $ServerInstance,

    [Parameter(Mandatory, ValueFromPipeline)]
    [int[]]
    $TCIDColl,

    [String]
    $Comment = ''
  )

  Begin
  {
  }
  Process
  {
    foreach ($TCID in $TCIDColl)
    {
      $Query = (@"
UPDATE [rmdb].[igelums].[THINCLIENT]
SET [TCCOMMENT] = '{0}'
WHERE [TCID] = '{1}'
"@ -f $Comment, $TCID)
      Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Query $Query
    }

  }
  End
  {
  }
}

