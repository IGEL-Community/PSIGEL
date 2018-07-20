function Remove-UMSThinclient
{
  <#
      .Synopsis
      Removes a thinclient from Rest API.

      .DESCRIPTION
      Removes a thinclient from Rest API.

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
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Remove-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 48381
      #Removes Thinclient with TCID 48381

      .EXAMPLE
      48381 | Remove-UMSThinclient -Computername 'UMSSERVER'
      #Removes Thinclient with TCID 48381
  #>

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
    Switch ($WebSession)
    {
      $null
      {
        $WebSession = New-UMSAPICookie -Computername $Computername
      }
    }
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}/deletetcoffline' -f $Computername, $TCPPort, $ApiVersion, $TCID
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Delete'
  }
  End
  {
  }
}

