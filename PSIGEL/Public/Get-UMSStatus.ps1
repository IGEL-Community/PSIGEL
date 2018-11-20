function Get-UMSStatus
{
  <#
      .Synopsis
      Gets diagnostic information about the UMS instance.

      .DESCRIPTION
      Gets diagnostic information about the UMS instance. Server status is the only
      resource that can be queried without logging in.
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
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
      }
      Get-UMSStatus @Params
      #Getting UMSSERVER status

      .EXAMPLE
      Get-UMSStatus -Computername 'UMSSERVER'
      #Getting UMSSERVER status without authorization, useful for connection debugging

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
    if ($null -eq $WebSession)
    {
      $WebSession = New-UMSAPICookie -Computername $Computername
    }

    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $Params = @{
      WebSession  = $WebSession
      Method      = 'Get'
      ContentType = 'application/json'
      Headers     = @{}
      Uri         = 'https://{0}:{1}/umsapi/v{2}/serverstatus' -f $UriArray
    }
    Invoke-UMSRestMethodWebSession @Params
  }
  End
  {
  }
}

