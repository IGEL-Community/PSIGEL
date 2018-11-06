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
  }
  Process
  {
    Switch ($WebSession)
    {
      $null
      {
        $WebSession = New-UMSAPICookie -Computername $Computername
      }
    }
    $Uri = 'https://{0}:{1}/umsapi/v{2}/serverstatus' -f $Computername, $TCPPort, $ApiVersion
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -Uri $Uri -Method 'Get'
  }
  End
  {
  }
}

