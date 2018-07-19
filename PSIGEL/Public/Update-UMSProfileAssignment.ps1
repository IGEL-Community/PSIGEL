function Update-UMSProfileAssignment
{
  <#
      .Synopsis
      Assigns a profile to a thin clients or a thin client directory.

      .DESCRIPTION
      Assigns a profile to a thin clients or a thin client directory.

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

      .PARAMETER TCID
      Thinclient ID to apply profile to

      .PARAMETER DirID
      Directory ID to apply profile to

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Update-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 471 -TCIDColl (100, 102)
      Assigns the profile with ProfilID 471 to thin client with TCID 100.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Update-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 471 -DirIDColl 300
      Assigns the profile with ProfilID 471 to thin client directory with DirID 300.
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

    [ValidateSet(2, 3)]
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
        $Body = [ordered]@{
          assignee = [ordered]@{
            id   = $ProfileID
            type = 'profile'
          }
          receiver = [ordered]@{
            id   = $TCID
            type = 'tc'
          }
        } | ConvertTo-Json
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/thinclients/' -f $Computername, $TCPPort, $ApiVersion, $ProfileID
      }
      'Dir'
      {
        $Body = [ordered]@{
          assignee = [ordered]@{
            id   = $ProfileID
            type = 'profile'
          }
          receiver = [ordered]@{
            id   = $DirID
            type = 'tcdirectory'
          }
        } | ConvertTo-Json
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/tcdirectories/' -f $Computername, $TCPPort, $ApiVersion, $ProfileID
      }
    }

    $InvokeRestMethodParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      Body        = '[{0}]' -f $Body
      ContentType = 'application/json; charset=utf-8'
      Method      = 'PUT'
      WebSession  = $WebSession
    }
    Invoke-RestMethod @InvokeRestMethodParams

  }
  End
  {
  }
}

