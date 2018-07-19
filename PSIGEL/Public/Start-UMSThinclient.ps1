function Start-UMSThinclient
{
  <#
      .Synopsis
      Wakes Up Thinclients (WOL) via API

      .DESCRIPTION
      Wakes Up Thinclients (WOL) via API

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
      Start-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
      Wakes up thin client with TCID 2433.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      2433, 2435 | Start-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession
      Wakes up thin clients with TCID 2433 and 2435.

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

    $URLEnd = '?command=wakeup'
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

