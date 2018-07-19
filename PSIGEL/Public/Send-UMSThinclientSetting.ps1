function Send-UMSThinclientSetting
{
  <#
      .Synopsis
      Sends settings modified in the UMS database to all thin clients listed in the request body immediately.

      .DESCRIPTION
      Sends settings modified in the UMS database to all thin clients listed in the request body immediately.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (2 or 3, Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCIDColl
      ThinclientIDs of the thinclients send settings to.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Send-UMSThinclientSetting -Computername $Computername -WebSession $WebSession -TCID 100
      Sends settings modified in the UMS database to thin client with TCID 100 immediately.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      100, 101 | Send-UMSThinclientSetting -Computername $Computername -WebSession $WebSession
      Sends settings modified in the UMS database to thin clients with TCID 100 and 101 immediately.

  #>

  [cmdletbinding()]
  param
  (
    [Parameter( Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0, 49151)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet(2, 3)]
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
        id   = $TCID
        type = "tc"
      } | ConvertTo-Json
    }

    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients?command=settings2tc' -f $Computername, $TCPPort, $ApiVersion

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

