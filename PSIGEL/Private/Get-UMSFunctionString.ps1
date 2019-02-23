function Get-UMSFunctionString
{
  <#
  .EXAMPLE
  Get-UMSFunctionString -Details 'short'

  .EXAMPLE
  Get-UMSFunctionString -Details 'full'

  .EXAMPLE
  Get-UMSFunctionString -Details 'online'

  .EXAMPLE
  Get-UMSFunctionString -Details 'shadow'

  #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateSet('short', 'details', 'online', 'shadow')]
    [string]
    $Facets
  )

  begin
  {
  }
  process
  {
    foreach ($item in $PSBoundParameters.GetEnumerator())
    {
      if ($item.Value)
      {
        switch ($item)
        {
          {$_.Key -eq 'Expand'}
          {
            $Value = 'true'
            continue
          }
          {$_.Value -is [int]}
          {
            $Value = ($item.Value).toString()
            continue
          }
          default
          {
            $Value = $item.Value
          }
        }
      }
      $FunctionString += ('&{0}={1}' -f $($item.Key).ToLower(), $Value)
    }
    $FunctionString -replace ('^&', '?')
  }
  end
  {
  }
}