function Get-UMSProfile
{
  <#
      .Synopsis
      Gets information on profiles on the UMS instance.

      .DESCRIPTION
      Gets information on profiles on the UMS instance.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ProfileID
      ThinclientID to search for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSProfile -Computername 'UMSSERVER' -WebSession $WebSession | Out-Gridview
      Gets information on all profiles on the UMS instance to Out-Gridview.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      100 | Get-UMSProfile -Computername 'UMSSERVER' -WebSession $WebSession
      Gets information on the profile with ProfileID 100.

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

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(ValueFromPipeline)]
    [int]
    $ProfileID = 0
  )

  Begin
  {
  }
  Process
  {

    Switch ($ProfileID)
    {
      0
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles' -f $Computername, $TCPPort, $ApiVersion
      }
      default
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $Computername, $TCPPort, $ApiVersion, $ProfileID
      }

    }

    $ThinclientsJSONCollParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      ContentType = 'application/json; charset=utf-8'
      Method      = 'Get'
      WebSession  = $WebSession
    }

    $ThinclientsJSONColl = Invoke-RestMethod @ThinclientsJSONCollParams
    $ThinclientsJSONColl

  }
  End
  {
  }
}

