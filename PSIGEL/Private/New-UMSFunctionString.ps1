function New-UMSFunctionString
{
  <#
  .EXAMPLE
  New-UMSFunctionString -Facet 'short' -Whatif

  .EXAMPLE
  New-UMSFunctionString -Facet 'full'

  .EXAMPLE
  New-UMSFunctionString -Facet 'online'

  .EXAMPLE
  New-UMSFunctionString -Facet 'shadow'

  .EXAMPLE
  New-UMSFunctionString -Facet 'children'

  #>

  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
  param (
    [Parameter(Mandatory)]
    [ValidateSet('short', 'details', 'online', 'shadow', 'children')]
    [string]
    $Facet
  )

  begin
  {
  }
  process
  {
    if ($PSCmdlet.ShouldProcess($Facet))
    {
      $Result = '?facets={0}' -f $Facet
    }
    $Result
  }
  end
  {
  }
}