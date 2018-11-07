function Reset-UMSThinclient
{
  <#
      .Synopsis
      Resets all thin clients listed in the request body to factory defaults and removes
      them from the UMS completely (without recycle bin).

      .DESCRIPTION
      Resets all thin clients listed in the request body to factory defaults and removes
      them from the UMS completely (without recycle bin).

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
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        TCID         = 35828
      }
      Reset-UMSThinclient @Params
      #Resets thin client with TCID 35828 to factory defaults.

      .EXAMPLE
      100, 101 | Reset-UMSThinclient -Computername $Computername
      #Resets thin clients with TCID 100 and 101 to factory defaults.
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

    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/thinclients/?command=tcreset2facdefs' -f $UriArray

    $Body = ConvertTo-Json @(
      @{
        id   = $TCID
        type = "tc"
      }
    )

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Body        = $Body
      Method      = 'Post'
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

