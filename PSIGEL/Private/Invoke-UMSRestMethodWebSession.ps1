function Invoke-UMSRestMethodWebSession
{
  <#
    .SYNOPSIS
    Invoke-RestMethod Wrapper for UMS API

    .DESCRIPTION
    Invoke-RestMethod Wrapper for UMS API

    .EXAMPLE
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -Method 'Get'

    .EXAMPLE
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -Body -Method 'Get'

    .NOTES
     n.a.
    #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory)]
    [string]
    $SessionURL,

    [switch]
    $Body,

    [Parameter(Mandatory)]
    [ValidateSet('Get', 'Post', 'Put', 'Delete')]
    [string]
    $Method
  )

  begin
  {
  }
  process
  {
    switch ($Body)
    {
      $true
      {
        $Params = @{
          Uri         = $SessionURL
          Headers     = @{}
          Body        = '[{0}]' -f $Body
          ContentType = 'application/json'
          Method      = $Method
          WebSession  = $WebSession
        }
      }
      Default
      {
        $Params = @{
          Uri         = $SessionURL
          Headers     = @{}
          ContentType = 'application/json'
          Method      = $Method
          WebSession  = $WebSession
        }
      }
    }
    Invoke-RestMethod @Params
  }
  end
  {
  }
}