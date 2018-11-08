function Remove-UMSThinclient
{
  <#
      .Synopsis
      Removes a thinclient completely (without recycle bin) from Rest API.

      .DESCRIPTION
      Removes a thinclient completely (without recycle bin) from Rest API.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCID
      ThinclientID of the thinclient to remove

      .EXAMPLE
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        TCID         = 48420
      }
      Remove-UMSThinclient @Params
      #Removes Thinclient with TCID 48420

      .EXAMPLE
      48381 | Remove-UMSThinclient -Computername 'UMSSERVER'
      #Removes Thinclient with TCID 48381
  #>

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
    $Uri = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}/deletetcoffline' -f $UriArray

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Method      = 'Delete'
      ContentType = 'application/json'
      Headers     = @{}
    }

    if ($PSCmdlet.ShouldProcess('TCID: {0}' -f $TCID))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}

