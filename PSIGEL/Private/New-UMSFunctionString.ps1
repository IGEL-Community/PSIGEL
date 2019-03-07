function New-UMSFunctionString
{
  <#
  .EXAMPLE
  New-UMSFunctionString -Filter 'short' -Whatif

  .EXAMPLE
  New-UMSFunctionString -Filter 'full'

  .EXAMPLE
  New-UMSFunctionString -Filter 'online'

  .EXAMPLE
  New-UMSFunctionString -Filter 'shadow'

  .EXAMPLE
  New-UMSFunctionString -Filter 'children'

  #>

  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
  param (
    [Parameter(Mandatory)]
    [ValidateSet('short', 'details', 'online', 'shadow', 'children')]
    [String]
    $Filter
  )

  begin
  {
  }
  process
  {
    if ($PSCmdlet.ShouldProcess($Filter))
    {
      $Result = '?facets={0}' -f $Filter
    }
    $Result
  }
  end
  {
  }
}