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
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCIDColl
      ThinclientIDs of the thinclients send settings to.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Send-UMSThinclientSetting -Computername 'UMSSERVER' -WebSession $WebSession -TCID 48426 -Confirm
      #Sends settings modified in the UMS database to thin client with TCID 48426 immediately.

      .EXAMPLE
      100, 101 | Send-UMSThinclientSetting -Computername $Computername
      #Sends settings modified in the UMS database to thin clients with TCID 100 and 101 immediately.

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
    $TCIDColl
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
    foreach ($TCID in $TCIDColl)
    {
      $Body = @{
        id   = $TCID
        type = "tc"
      } | ConvertTo-Json
      $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients?command=settings2tc' -f $Computername, $TCPPort, $ApiVersion
      if ($PSCmdlet.ShouldProcess('TCID: {0}' -f $TCID))
      {
        Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -BodySquareWavy $Body -Method 'Post'
      }
    }
  }
  End
  {
  }
}

