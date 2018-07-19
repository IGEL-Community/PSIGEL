function Get-UMSStatus
{
  <#
      .Synopsis
      Gets diagnostic information about the UMS instance.

      .DESCRIPTION
      Gets diagnostic information about the UMS instance.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSStatus -Computername 'UMSSERVER' -WebSession $WebSession

  #>

  [cmdletbinding()]
  param
  (
    [Parameter( Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0, 65535)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

    $WebSession = $false
  )

  Begin
  {
  }
  Process
  {
    Switch ($WebSession)
    {
      $false
      {
        $WebSession = New-UMSAPICookie -Computername $Computername
      }
    }
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/serverstatus' -f $Computername, $TCPPort, $ApiVersion
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get'
  }
  End
  {
  }
}

