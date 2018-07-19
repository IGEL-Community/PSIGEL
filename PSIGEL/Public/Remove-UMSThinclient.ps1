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
      API Version to use (2 or 3, Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCID
      ThinclientID of the thinclient to remove

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      Remove-UMSThinclient -Computername $Computername -WebSession $WebSession -TCID 100
      Removes Thinclient with TCID 100

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      100 | Remove-UMSThinclient -Computername $Computername -WebSession $WebSession
      Removes Thinclient with TCID 100
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

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

    [Parameter(Mandatory)]
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

    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}/deletetcoffline' -f $Computername, $TCPPort, $ApiVersion, $TCID

    $ThinclientsJSONCollParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      ContentType = 'application/json'
      Method      = 'Delete'
      WebSession  = $WebSession
    }

    $ThinclientsJSONColl = Invoke-RestMethod @ThinclientsJSONCollParams
    $ThinclientsJSONColl
  }
  End
  {
  }
}

