function Remove-UMSProfileAssignment
{
  <#
      .Synopsis
      Deletes assignment of the specified profile to the specified thin cient or thin client directory.

      .DESCRIPTION
      Deletes assignment of the specified profile to the specified thin cient or thin client directory.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (2 or 3, Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ProfileID
      ProfileID to search for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      Remove-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 471 -TCID 100
      Deletes assignment of profile with ProfileID 471 to the thin cient with the TCID 100.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      Remove-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 471 -DirID 300
      Deletes assignment of profile with ProfileID 471 to the thin cient directory with the DirID 300.
  #>

  [cmdletbinding()]
  param
  (
    [Parameter( Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0,49151)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet(2,3)]
    [Int]
    $ApiVersion = 3,

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory)]
    [int]
    $ProfileID,

    [Parameter(Mandatory,
    ParameterSetName = 'TC')]
    [int]
    $TCID,

    [Parameter(Mandatory,
    ParameterSetName = 'Dir')]
    [int]
    $DirID
  )

  Begin
  {
  }
  Process
  {

    switch ($PSCmdlet.ParameterSetName)
    {
      'TC'
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/thinclients/{4}' -f $Computername, $TCPPort, $ApiVersion, $ProfileID, $TCID
      }
      'Dir'
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/tcdirectories/{4}' -f $Computername, $TCPPort, $ApiVersion, $ProfileID, $DirID
      }
    }


    $ThinclientsJSONCollParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      ContentType = 'application/json; charset=utf-8'
      Method      = 'DELETE'
      WebSession  = $WebSession
    }

    $ThinclientsJSONColl = Invoke-RestMethod @ThinclientsJSONCollParams
    $ThinclientsJSONColl

  }
  End
  {
  }
}

