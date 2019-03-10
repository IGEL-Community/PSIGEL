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
    Add-Type -AssemblyName Microsoft.PowerShell.Commands.Utility
    Add-Type -TypeDefinition @'
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
              return true;
            }
          }
'@
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