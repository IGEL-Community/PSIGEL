function Restart-UMSThinclient
{
  <#
      .Synopsis
      Restarts Thinclients via API

      .DESCRIPTION
      Restarts Thinclients via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCID
      ThinclientIDs to wake up

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Restart-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
      Restarts thin client with TCID 2433.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      2433, 2435 | Restart-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession
      Restarts thin clients with TCID 2433 and 2435.

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

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory, ValueFromPipeline)]
    [int]
    $TCIDColl
  )

  Begin
  {
  }
  Process
  {

    $Body = foreach ($TCID in $TCIDColl)
    {
      @{
        id = $TCID
        type = "tc"
      } | ConvertTo-Json
    }

    $URLEnd = '?command=reboot'
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients{3}' -f $Computername, $TCPPort, $ApiVersion, $URLEnd

    $ThinclientsJSONCollParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      Body        = '[{0}]' -f $Body
      ContentType = 'application/json'
      Method      = 'Post'
      WebSession  = $WebSession
    }

    $ThinclientsJSONColl = Invoke-RestMethod @ThinclientsJSONCollParams
    $ThinclientsJSONColl

  }
  End
  {
  }
}

