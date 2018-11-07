function Move-UMSThinclientDirectory
{
  <#
      .Synopsis
      Moves Thinclient Directories into the specified Thinclient Directory via API

      .DESCRIPTION
      Moves Thinclient Directories into the specified Thinclient Directory via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER DIRID
      DIRIDs to move

      .PARAMETER DDIRID
      DDIRID to move to

      .EXAMPLE
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        DIRID        = 49289
        DDIRID       = 49552
        Confirm      = $true
      }
      Move-UMSThinclientDirectory @Params
      #Moves Thinclient Directorie with ID 49289 into the Thinclient Directory with ID 49552
      #and prompts for confirmation

      .EXAMPLE
      49289, 49291 | Move-UMSThinclientDirectory -Computername 'UMSSERVER' -DDIRID 772
      #Moves Thinclient Directories into the specified Thinclient Directory

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
    $Uri = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/{3}?operation=move' -f $UriArray
    $Body = ConvertTo-Json @(
      @{
        id   = $DIRID
        type = "tcdirectory"
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

    if ($PSCmdlet.ShouldProcess(('DIRID: {0} to DDIRID: {1}' -f $DIRID, $DDIRID)))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}