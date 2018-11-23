function Remove-UMSProfileAssignment
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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
    $ProfileID,

    [Parameter(Mandatory, ParameterSetName = 'TC')]
    [int]
    $TCID,

    [Parameter(Mandatory, ParameterSetName = 'Dir')]
    [int]
    $DirID
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

    Switch ($PSCmdlet.ParameterSetName)
    {
      'TC'
      {
        $UriArray = @($Computername, $TCPPort, $ApiVersion, $ProfileID, $TCID)
        $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/thinclients/{4}' -f $UriArray
        $ID = $TCID
      }
      'Dir'
      {
        $UriArray = @($Computername, $TCPPort, $ApiVersion, $ProfileID, $DirID)
        $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/tcdirectories/{4}' -f $UriArray
        $ID = $DirID
      }
    }

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Method      = 'Delete'
      ContentType = 'application/json'
      Headers     = @{}
    }

    $SPArray = @($ProfileID, $($PSCmdlet.ParameterSetName), $ID)
    if ($PSCmdlet.ShouldProcess(('ProfileID: {0}, {1}ID: {2}' -f $SPArray)))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}

