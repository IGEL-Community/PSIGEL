function Get-UMSThinclientAssignment
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

    $WebSession,

    [Parameter(Mandatory, ValueFromPipeline)]
    [int]
    $TCID
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

    $UriArray = @($Computername, $TCPPort, $ApiVersion, $TCID)
    $Params = @{
      WebSession  = $WebSession
      Uri         = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}/assignments/profiles' -f $UriArray
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

