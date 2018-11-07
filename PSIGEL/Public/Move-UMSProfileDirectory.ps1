function Move-UMSProfileDirectory
{
  <#
      .Synopsis
      Moves Profile Directories into the specified Profile Directory via API

      .DESCRIPTION
      Moves Profile Directories into the specified Profile Directory via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ProfileID
      DIRIDs to move

      .PARAMETER DDIRID
      DIRID to move to

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Move-UMSProfileDirectory -Computername 'UMSSERVER' -WebSession $WebSession -DDIRID 28793 -DIRID 49339 -Confirm
      #Moves Profile Directory into the specified Profile Directory

      .EXAMPLE
      49339, 49341 | Move-UMSProfileDirectory -Computername 'UMSSERVER' -DDIRID -2
      #Moves Profile Directories into the specified Profile Directory

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
    $DIRID,

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
      id   = $DIRID
      type = "profiledirectory"
    } | ConvertTo-Json
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/{3}?operation=move' -f $Computername,
    $TCPPort, $ApiVersion, $DDIRID
    if ($PSCmdlet.ShouldProcess(('ProfileID: {0} to DDIRID: {1}' -f $DIRID, $DDIRID)))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -BodySquareWavy $Body -Method 'Put'
    }
  }
  End
  {
  }
}