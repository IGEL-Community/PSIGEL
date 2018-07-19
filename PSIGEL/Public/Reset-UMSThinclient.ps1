function Reset-UMSThinclient
{
  <#
      .Synopsis
      Resets all thin clients listed in the request body to factory defaults.

      .DESCRIPTION
      Resets all thin clients listed in the request body to factory defaults.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCIDColl
      ThinclientIDs of the thinclients to reset to factory defaults.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Reset-UMSThinclient -Computername $Computername -WebSession $WebSession -TCID 100
      Resets thin client with TCID 100 to factory defaults.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      100, 101 | Reset-UMSThinclient -Computername $Computername -WebSession $WebSession
      Resets thin clients with TCID 100 and 101 to factory defaults.

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

    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients/?command=tcreset2facdefs' -f $Computername, $TCPPort, $ApiVersion

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

