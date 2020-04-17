function Invoke-UMSRestMethodWebSession
{
  <#
    .SYNOPSIS
    Invoke-RestMethod Wrapper for UMS API

    .DESCRIPTION
    Invoke-RestMethod Wrapper for UMS API

    .EXAMPLE
    $Params = @{
      WebSession       = $WebSession
      Uri              = $Uri
      Method           = 'Put'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    Invoke-UMSRestMethodWebSession @Params

    .EXAMPLE
    $Params = @{
      WebSession       = $WebSession
      Uri              = $Uri
      Body             = $Body
      Method           = 'Put'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    Invoke-UMSRestMethodWebSession @Params

  #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory)]
    [ValidateSet('Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol,

    [Parameter(Mandatory)]
    [String]
    $Uri,

    [String]
    $Body,

    [String]
    $ContentType,

    $Headers,

    [Parameter(Mandatory)]
    [ValidateSet('Get', 'Post', 'Put', 'Delete')]
    [String]
    $Method
  )

  begin
  {
    $null = $PSBoundParameters.Remove('SecurityProtocol')
    switch ($PSEdition)
    {
      'Core'
      {
        $PSBoundParameters.Add('SkipCertificateCheck', $true)
        $PSBoundParameters.Add('SslProtocol', $SecurityProtocol)
      }
    }
  }
  process
  {
    switch ($PSEdition)
    {
      'Desktop'
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
              Write-Warning -Message ('Bad Request: The request does not match the API, e.g. it uses the wrong HTTP method. Uri: {0} Method: {1}' -f $Uri, $Method)
            }
            401
            {
              Write-Warning -Message ('Unauthorized: The client has not logged in or has sent the wrong credentials. Uri: {0} Method: {1}' -f $Uri, $Method)
            }
            404
            {
              Write-Warning -Message ('Not Found: The endpoint does not exist, it may be misspelled. Uri: {0} Method: {1}' -f $Uri, $Method)
            }
            415
            {
              Write-Warning -Message ('Unsupported Media Type: The body content, e.g. JSON, does not match the Content-Type header or is not well-formed. Uri: {0} Method: {1}' -f $Uri, $Method)
            }
            500
            {
              Write-Warning -Message ('Internal Server Error: The server has encountered an error, check the server logfiles catalina.log and stderr. Uri: {0} Method: {1}' -f $Uri, $Method)
            }
            default
            {
              Write-Warning -Message ('Some error occured see HTTP status code {0} for further details. Uri: {1} Method: {2}' -f $PSItem.Exception.Response.StatusCode, $Uri, $Method)
            }
          }

        }
      }
      'Core'
      {
        try
        {
          Invoke-RestMethod @PSBoundParameters -ErrorAction Stop
        }
        catch [Microsoft.PowerShell.Commands.HttpResponseException]
        {
          switch ($($PSItem.Exception.Response.StatusCode.value__))
          {
            400
            {
              Write-Warning -Message ('Bad Request: The request does not match the API, e.g. it uses the wrong HTTP method. Uri: {0} Method: {1}' -f $Uri, $Method)
            }
            401
            {
              Write-Warning -Message ('Unauthorized: The client has not logged in or has sent the wrong credentials. Uri: {0} Method: {1}' -f $Uri, $Method)
            }
            404
            {
              Write-Warning -Message ('Not Found: The endpoint does not exist, it may be misspelled. Uri: {0} Method: {1}' -f $Uri, $Method)
            }
            415
            {
              Write-Warning -Message ('Unsupported Media Type: The body content, e.g. JSON, does not match the Content-Type header or is not well-formed. Uri: {0} Method: {1}' -f $Uri, $Method)
            }
            500
            {
              Write-Warning -Message ('Internal Server Error: The server has encountered an error, check the server logfiles catalina.log and stderr. Uri: {0} Method: {1}' -f $Uri, $Method)
            }
            default
            {
              Write-Warning -Message ('Some error occured see HTTP status code {0} for further details. Uri: {1} Method: {2}' -f $PSItem.Exception.Response.StatusCode, $Uri, $Method)
            }
          }
        }
      }
    }
  }
  end
  {
  }
}