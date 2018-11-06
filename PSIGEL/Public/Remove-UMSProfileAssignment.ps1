function Remove-UMSProfileAssignment
{
  <#
      .Synopsis
      Deletes assignment of the specified profile to the specified Thinclient or Thinclient directory.

      .DESCRIPTION
      Deletes assignment of the specified profile to the specified Thinclient or Thinclient directory.

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
      Remove-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 470 -TCID 48426
      #Deletes assignment of profile with ProfileID 470 to the Thinclient with the TCID 48426.

      .EXAMPLE
      48170  | Remove-UMSProfileAssignment -Computername 'UMSSERVER' -DirID 185
      #Deletes assignment of profile with ProfileID 48170 to the Thinclient directory with the DirID 185.
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
        $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/thinclients/{4}' -f $Computername,
        $TCPPort, $ApiVersion, $ProfileID, $TCID
        $ID = $TCID
      }
      'Dir'
      {
        $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/tcdirectories/{4}' -f $Computername,
        $TCPPort, $ApiVersion, $ProfileID, $DirID
        $ID = $DirID
      }
    }
    if ($PSCmdlet.ShouldProcess(('ProfileID: {0}, {1}ID: {2}' -f $ProfileID, $($PSCmdlet.ParameterSetName), $ID)))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -Uri $Uri -Method 'Delete'
    }
  }
  End
  {
  }
}

