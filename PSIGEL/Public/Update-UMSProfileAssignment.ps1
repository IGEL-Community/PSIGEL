function Update-UMSProfileAssignment
{
  <#
      .Synopsis
      Assigns a profile to a Thinclient or a tThinclient directory.

      .DESCRIPTION
      Assigns a profile to a Thinclient or a tThinclient directory.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ProfileID
      ProfileID to search for

      .PARAMETER TCID
      Thinclient ID to apply profile to

      .PARAMETER DirID
      Directory ID to apply profile to

      .EXAMPLE
      $Params = @{
        $WebSession   = New-UMSAPICookie -Computername 'UMSSERVER'
        $Computername = 'UMSSERVER'
        $WebSession   = $WebSession
        $ProfileID    = 470
        $TCID         = 48426
      }
      Update-UMSProfileAssignment @Params
      #Assigns the profile with ProfilID 470 to thin client with TCID 48426.

      .EXAMPLE
      Update-UMSProfileAssignment -Computername 'UMSSERVER' -ProfileID 471 -DirID 300
      #Assigns the profile with ProfilID 471 to thin client directory with DirID 300.

      #Update-UMSProfileAssignment -ProfileID 48440 -DirID 49289 -Computername 'SRVUMS02'
  #>

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

