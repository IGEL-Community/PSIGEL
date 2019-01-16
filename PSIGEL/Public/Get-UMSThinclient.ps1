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
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients' -f $UriArray)
    $Params = @{
      WebSession  = $WebSession
      Method      = 'Get'
      ContentType = 'application/json'
      Headers     = @{}
    }
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
        $FunctionString = ''
      }
      'full'
      {
        $FunctionString = '?facets=details'
      }
      'online'
      {
        $FunctionString = '?facets=online'
      }
      'shadow'
      {
        $FunctionString = '?facets=shadow'
      }
    }
    Switch ($TCID)
    {
      0
      {
        $params.Add('Uri', ('{0}{1}' -f $BaseURL, $FunctionString))
        (Invoke-UMSRestMethodWebSession @Params).SyncRoot
      }
      default
      {
        $params.Add('Uri', ('{0}/{1}{2}' -f $BaseURL, $TCID, $FunctionString))
        Invoke-UMSRestMethodWebSession @Params
      }
    }
  }
  End
  {
  }
}
