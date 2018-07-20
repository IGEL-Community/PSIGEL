function Get-UMSFirmware
{
  <#
      .Synopsis
      Gets information on all firmwares known to the UMS from API.

      .DESCRIPTION
      Gets information on all firmwares known to the UMS from API.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER FirmwareID
      ThinclientID to search for

      .EXAMPLE
      Get-UMSFirmware -Computername 'UMSSERVER'
      #Gets information on all firmwares known to the UMS.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      9, 7 | Get-UMSFirmware -Computername 'UMSSERVER' -WebSession $WebSession
      #Gets information on firmwares with FirmwareIDs 9 and 7.

  #>

  [cmdletbinding()]
  param
  (
    [String]
    $Computername,

    [ValidateRange(0, 49151)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

    $WebSession,

    [Parameter(ValueFromPipeline)]
    [int]
    $FirmwareID = 0
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
    Switch ($FirmwareID)
    {
      0
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/firmwares' -f $Computername, $TCPPort, $ApiVersion
        (Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get').FwResource
      }
      default
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/firmwares/{3}' -f $Computername, $TCPPort, $ApiVersion, $FirmwareID
        Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get'
      }
    }
  }
  End
  {
  }
}