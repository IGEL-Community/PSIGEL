function Get-UMSStatus
{
  <#
      .Synopsis
      Gets diagnostic information about the UMS instance.

      .DESCRIPTION
      Gets diagnostic information about the UMS instance. Server status is the only resource that can be queried without logging in.
      This makes it useful for debugging the connection to the IMI service

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .EXAMPLE
      Get-UMSStatus -Computername 'UMSSERVER'
      #Getting UMSSERVER status without authorization, useful for connection debugging

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSStatus -Computername 'UMSSERVER' -WebSession $WebSession
      #Getting UMSSERVER status

  #>

  [cmdletbinding()]
  param
  (
    [Parameter(Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0, 65535)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

    $WebSession
  )

  Begin
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
  }
  Process
  {
    [Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
    $Method = 'Get'
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/serverstatus' -f $Computername, $TCPPort, $ApiVersion
    $Params = @{
      Uri         = $SessionURL
      Headers     = @{}
      ContentType = 'application/json'
      Method      = $Method
    }
    try
    {
      Invoke-RestMethod @Params -ErrorAction Stop
    }
    catch [System.Net.WebException]
    {
      switch ($($PSItem.Exception.Response.StatusCode.value__))
      {
        400
        {
          Write-Warning -Message ('Error executing IMI RestAPI request. SessionURL: {0} Method: {1}' -f $SessionURL, $Method)
        }
        401
        {
          Write-Warning -Message ('Error logging in, it seems as you have entered invalid credentials. SessionURL: {0} Method: {1}' -f $SessionURL, $Method)
        }
        403
        {
          Write-Warning -Message ('Error logging in, it seems as you have not subscripted this version of IMI. SessionURL: {0} Method: {1}' -f $SessionURL, $Method)
        }
        default
        {
          Write-Warning -Message ('Some error occured see HTTP status code for further details. SessionURL: {0} Method: {1}' -f $SessionURL, $Method)
        }
      }
    }
  }
  End
  {
  }
}

