function Move-UMSProfile
{
  <#
      .Synopsis
      Moves Profiles into the specified Profile Directory via API

      .DESCRIPTION
      Moves Profiles into the specified Profile Directory via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ProfileID
      ProfileIDs to move

      .PARAMETER DDIRID
      DDIRID to move to

      .EXAMPLE
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        DDIRID       = 49339
        ProfileID    = 48440
        Confirm      = $true
      }
      Move-UMSProfile @Params
      #Moves Profile with ID 48440 into the Profile Directory with ID 48440
      #and prompts for confirmation

      .EXAMPLE
      48440, 48442 | Move-UMSProfile -Computername 'UMSSERVER' -DDIRID 28793
      #Moves Profiles into the specified Profile Directory

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
    $ProfileID,

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
        id   = $ProfileID
        type = "profile"
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

    if ($PSCmdlet.ShouldProcess(('ProfileID: {0} to DDIRID: {1}' -f $ProfileID, $DDIRID)))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}