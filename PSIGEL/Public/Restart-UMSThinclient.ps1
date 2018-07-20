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
      Restart-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 48426
      #Restarts thin client with TCID 48426.

      .EXAMPLE
      48426, 2435 | Restart-UMSThinclient -Computername 'UMSSERVER'
      #Restarts thin clients with TCID 48426 and 2435.

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
      $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients?command=reboot' -f $Computername, $TCPPort, $ApiVersion
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

