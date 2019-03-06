function New-UMSFunctionString
{
  <#
  .EXAMPLE
  New-UMSFunctionString -Option 'short' -Whatif

  .EXAMPLE
  New-UMSFunctionString -Option 'full'

  .EXAMPLE
  New-UMSFunctionString -Option 'online'

  .EXAMPLE
  New-UMSFunctionString -Option 'shadow'

  .EXAMPLE
  New-UMSFunctionString -Option 'children'

  #>

  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
  param (
    [Parameter(Mandatory)]
    [ValidateSet('short', 'details', 'online', 'shadow', 'children')]
    [String]
    $Option
  )

  begin
  {
  }
  process
  {
    if ($PSCmdlet.ShouldProcess($Option))
    {
      $Result = '?facets={0}' -f $Option
    }
    $Result
  }
  end
  {
  }
}