function Get-UMSFirmware
{
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
    if ($null -eq $WebSession)
    {
      $WebSession = New-UMSAPICookie -Computername $Computername
    }

    $Params = @{
      WebSession  = $WebSession
      Method      = 'Get'
      ContentType = 'application/json'
      Headers     = @{}
    }

    Switch ($FirmwareID)
    {
      0
      {
        $UriArray = @($Computername, $TCPPort, $ApiVersion)
        $Params.Uri = 'https://{0}:{1}/umsapi/v{2}/firmwares' -f $UriArray
        (Invoke-UMSRestMethodWebSession @Params).FwResource
      }
      default
      {
        $UriArray = @($Computername, $TCPPort, $ApiVersion, $FirmwareID)
        $Params.Uri = 'https://{0}:{1}/umsapi/v{2}/firmwares/{3}' -f $UriArray
        Invoke-UMSRestMethodWebSession @Params
      }
    }
  }
  End
  {
  }
}