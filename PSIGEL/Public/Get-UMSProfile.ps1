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
      Get-UMSProfile -Computername 'UMSSERVER' -WebSession $WebSession
      Gets information on all profiles on the UMS instance.

      .EXAMPLE
      499, 501 | Get-UMSProfile -Computername 'UMSSERVER'
      Gets information on the profile with ProfileID 499 and 501.

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

    $WebSession = $false,

    [Parameter(ValueFromPipeline)]
    [int]
    $ProfileID = 0
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
    Switch ($ProfileID)
    {
      0
      {
        $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles' -f $Computername, $TCPPort, $ApiVersion
      }
      default
      {
        $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $Computername, $TCPPort, $ApiVersion, $ProfileID
      }
    }
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -Uri $Uri -Method 'Get'
  }
  End
  {
  }
}

