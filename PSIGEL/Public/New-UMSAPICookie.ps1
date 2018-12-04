function New-UMSAPICookie
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
  param
  (
    [Parameter(Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0, 65535)]
    [Int]
    $TCPPort = 8443,

    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $Credential = (Get-Credential -Message 'Enter your credentials'),

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3
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
    $UserName = $Credential.UserName
    $Password = $Credential.GetNetworkCredential().password

    [Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $BUArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = 'https://{0}:{1}/umsapi/v{2}/' -f $BUArray
    $Header = @{
      'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($UserName + ':' + $Password))
    }

    $Params = @{
      Uri         = '{0}login' -f $BaseURL
      Headers     = $Header
      Method      = 'Post'
      ContentType = 'application/json'
      ErrorAction = 'Stop'
    }

    Try
    {
      $SessionResponse = Invoke-RestMethod @Params
      $Cookie = New-Object -TypeName System.Net.Cookie
      $Cookie.Name = ($SessionResponse.Message).Split('=')[0]
      $Cookie.Path = '/'
      $Cookie.Value = ($SessionResponse.Message).Split('=')[1]
      $Cookie.Domain = $Computername
    }
    Catch
    {
      $_.Exception.Message
    }

    if ($PSCmdlet.ShouldProcess($Computername))
    {
      $WebSession = New-Object -TypeName Microsoft.Powershell.Commands.Webrequestsession
      $WebSession.Cookies.Add($Cookie)
      $WebSession
    }
  }
  End
  {
  }
}