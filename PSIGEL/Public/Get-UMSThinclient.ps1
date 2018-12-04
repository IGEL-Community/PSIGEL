function Get-UMSThinclient
{
  [cmdletbinding()]
  param
  (
    [String]
    $Computername,

    [ValidateRange(0, 65535)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

    $WebSession,

    [ValidateSet('short', 'full', 'online', 'shadow')]
    [String]
    $Details = 'short',

    [Parameter(ValueFromPipeline)]
    [int]
    $TCID = 0
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

    Switch ($Details)
    {
      'short'
      {
        $URLEnd = ''
      }
      'full'
      {
        $URLEnd = '?facets=details'
      }
      'online'
      {
        $URLEnd = '?facets=online'
      }
      'shadow'
      {
        $URLEnd = '?facets=shadow'
      }
    }
    Switch ($TCID)
    {
      0
      {
        $UriArray = @($Computername, $TCPPort, $ApiVersion, $URLEnd)
        $Uri = 'https://{0}:{1}/umsapi/v{2}/thinclients{3}' -f $UriArray
      }
      default
      {
        $UriArray = @($Computername, $TCPPort, $ApiVersion, $TCID, $URLEnd)
        $Uri = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}{4}' -f $UriArray
      }
    }

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Method      = 'Get'
      ContentType = 'application/json'
      Headers     = @{}
    }
    Invoke-UMSRestMethodWebSession @Params
  }
  End
  {
  }
}
