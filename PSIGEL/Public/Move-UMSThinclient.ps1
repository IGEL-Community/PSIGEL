function Move-UMSThinclient
{
  <#
      .Synopsis
      Moves Thinclients into the specified Thinclient Directory via API

      .DESCRIPTION
      Moves Thinclients into the specified Thinclient Directory via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCID
      TCIDs to move

      .PARAMETER DIRID
    , TCID: {2} DIRID to , $TCIDmove to

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Move-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -DIRID 49552 -TCID 49282

      .EXAMPLE
      49282, 49284 | Move-UMSThinclient -Computername 'UMSSERVER' -DIRID 49289
      #Moves Thinclients into the specified Thinclient Directory

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
    $TCID,

    [Parameter(Mandatory)]
    [int]
    $DIRID
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
    $Body = @{
      id   = $TCID
      type = "tc"
    } | ConvertTo-Json
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/{3}?operation=move' -f $Computername,
    $TCPPort, $ApiVersion, $DIRID
    if ($PSCmdlet.ShouldProcess(('TCID: {0} to DIRID: {1}' -f $TCID, $DIRID)))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -BodySquareWavy $Body -Method 'Put'
    }
  }
  End
  {
  }
}