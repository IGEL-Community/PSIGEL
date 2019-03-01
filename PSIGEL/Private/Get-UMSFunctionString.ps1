function Get-UMSFunctionString
{
  <#
  .EXAMPLE
  Get-UMSFunctionString -Facets 'short'

  .EXAMPLE
  Get-UMSFunctionString -Facets 'full'

  .EXAMPLE
  Get-UMSFunctionString -Facets 'online'

  .EXAMPLE
  Get-UMSFunctionString -Facets 'shadow'

  .EXAMPLE
  Get-UMSFunctionString -Facets 'children'

  #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateSet('short', 'details', 'online', 'shadow', 'children')]
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