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
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        DIRID        = 49339
        DDIRID       = 28793
        Confirm      = $true
      }
      Move-UMSProfileDirectory @Params
      #Moves Profile Directory with ID 49339 into the Profile Directory with ID 28793
      #and prompts for confirmation

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

    $UriArray = @($Computername, $TCPPort, $ApiVersion, $DDIRID)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/{3}?operation=move' -f $UriArray
    $Body = ConvertTo-Json @(
      @{
        id   = $DIRID
        type = "profiledirectory"
      }
    )

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Body        = $Body
      Method      = 'Put'
      ContentType = 'application/json'
      Headers     = @{}
    }

    if ($PSCmdlet.ShouldProcess(('ProfileID: {0} to DDIRID: {1}' -f $DIRID, $DDIRID)))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}