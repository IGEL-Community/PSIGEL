function Invoke-UMSRestMethodWebSession
{
  <#
    .SYNOPSIS
    Invoke-RestMethod Wrapper for UMS API

    .DESCRIPTION
    Invoke-RestMethod Wrapper for UMS API

    .EXAMPLE
    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Method      = 'Put'
      ContentType = 'application/json'
      Headers     = @{}
    }
    Invoke-UMSRestMethodWebSession @Params

    .EXAMPLE
    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Body        = $Body
      Method      = 'Put'
      ContentType = 'application/json'
      Headers     = @{}
    }
    Invoke-UMSRestMethodWebSession @Params

  #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    $WebSession,

    [ValidateSet('Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol = 'Tls12',

    [Parameter(Mandatory)]
    [string]
    $Uri,

    [string]
    $Body,

    [string]
    $ContentType,

    $Headers,

    [Parameter(Mandatory)]
    [ValidateSet('Get', 'Post', 'Put', 'Delete')]
    [string]
    $Method
  )

  begin
  {
    [Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
    [Net.ServicePointManager]::SecurityProtocol = $SecurityProtocol -join ','
    $null = $PSBoundParameters.Remove('SecurityProtocol')
  }
  process
  {
    try
    {
      Invoke-RestMethod @PSBoundParameters -ErrorAction Stop
    }
    catch [System.Net.WebException]
    {
      switch ($($PSItem.Exception.Response.StatusCode.value__))
      {
        400
        {
          Write-Warning -Message ('Error executing IMI RestAPI request. Uri: {0} Method: {1}' -f $Uri, $Method)
        }
        401
        {
          Write-Warning -Message ('Error logging in, it seems as you have entered invalid credentials. Uri: {0} Method: {1}' -f $Uri, $Method)
        }
        403
        {
          Write-Warning -Message ('Error logging in, it seems as you have not subscripted this version of IMI. Uri: {0} Method: {1}' -f $Uri, $Method)
        }
        415
        {
          Write-Warning -Message ('Unsupported Media Type. Uri: {0} Method: {1}' -f $Uri, $Method)
        }
        default
        {
          Write-Warning -Message ('Some error occured see HTTP status code for further details. Uri: {0} Method: {1}' -f $Uri, $Method)
        }
      }
    }
  }
  end
  {
  }
}