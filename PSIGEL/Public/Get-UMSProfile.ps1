function Get-UMSProfile
{
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

    Switch ($ProfileID)
    {
      0
      {
        $UriArray = @($Computername, $TCPPort, $ApiVersion)
        $Params.Uri = 'https://{0}:{1}/umsapi/v{2}/profiles' -f $UriArray
      }
      default
      {
        $UriArray = @($Computername, $TCPPort, $ApiVersion, $ProfileID)
        $Params.Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $UriArray
      }
    }
    Invoke-UMSRestMethodWebSession @Params
  }
  End
  {
  }
}

