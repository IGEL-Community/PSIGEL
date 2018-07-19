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
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ProfileID
      ProfileID to search for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Remove-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 48170 -TCID 4138
      #Deletes assignment of profile with ProfileID 48170 to the thin cient with the TCID 4138.

      .EXAMPLE
      Remove-UMSProfileAssignment -Computername 'UMSSERVER' -ProfileID 48170 -DirID 185
      #Deletes assignment of profile with ProfileID 48170 to the thin cient directory with the DirID 185.
  #>

  [cmdletbinding()]
  param
  (
    [Parameter( Mandatory)]
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
    Switch ($WebSession)
    {
      $null
      {
        $WebSession = New-UMSAPICookie -Computername $Computername
      }
    }
    Switch ($PSCmdlet.ParameterSetName)
    {
      'TC'
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/thinclients/{4}' -f $Computername,
        $TCPPort, $ApiVersion, $ProfileID, $TCID
      }
      'Dir'
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/tcdirectories/{4}' -f $Computername,
        $TCPPort, $ApiVersion, $ProfileID, $DirID
      }
    }
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Delete'
  }
  End
  {
  }
}

