function Stop-UMSThinclient
{
  <#
      .Synopsis
      Shuts Down Thinclients via API

      .DESCRIPTION
      Shuts Down Thinclients via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCID
      ThinclientIDs to shut down

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Stop-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 48426
      #Shuts down thin client with TCID 48426.

      .EXAMPLE
      48426, 2435 | Stop-UMSThinclient -Computername 'UMSSERVER'
      #Shuts down thin clients with TCID 48426 and 2435.

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
    if ($null -eq $WebSession)
    {
      $WebSession = New-UMSAPICookie -Computername $Computername
    }
    
    foreach ($TCID in $TCIDColl)
    {
      $Body = @{
        id   = $TCID
        type = "tc"
      } | ConvertTo-Json
      $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients?command=shutdown' -f $Computername, $TCPPort, $ApiVersion
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