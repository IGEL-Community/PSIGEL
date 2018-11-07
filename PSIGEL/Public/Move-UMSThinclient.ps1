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

      .PARAMETER DDIRID
      DDIRID to move to

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Move-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -DDIRID 49552 -TCID 49282 -Confirm
      #Moves Thinclient into the specified Thinclient Directory

      .EXAMPLE
      49282, 49284 | Move-UMSThinclient -Computername 'UMSSERVER' -DDIRID 49289
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
    $DDIRID
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
    
    $Body = @{
      id   = $TCID
      type = "tc"
    } | ConvertTo-Json
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/{3}?operation=move' -f $Computername,
    $TCPPort, $ApiVersion, $DDIRID
    if ($PSCmdlet.ShouldProcess(('TCID: {0} to DDIRID: {1}' -f $TCID, $DDIRID)))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -BodySquareWavy $Body -Method 'Put'
    }
  }
  End
  {
  }
}