function Update-UMSProfileAssignment
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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

    [Parameter(Mandatory)]
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

    switch ($PSCmdlet.ParameterSetName)
    {
      'TC'
      {
        $Body = ConvertTo-Json @(
          @{
            assignee = @{
              id   = "$ProfileID"
              type = 'profile'
            }
            receiver = @{
              id   = "$TCID"
              type = 'tc'
            }
          }
        )
        $UrlEnd = 'thinclients/'
        $ID = $TCID
      }
      'Dir'
      {
        $Body = ConvertTo-Json @(
          @{
            assignee = @{
              id   = "$ProfileID"
              type = 'profile'
            }
            receiver = @{
              id   = "$DirID"
              type = 'tcdirectory'
            }
          }
        )
        $UrlEnd = 'tcdirectories/'
        $ID = $DirID
      }
    }

    $UriArray = @($Computername, $TCPPort, $ApiVersion, $ProfileID, $UrlEnd)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/{4}' -f $UriArray

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Body        = $Body
      Method      = 'Put'
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

