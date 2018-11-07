function Remove-UMSProfileDirectory
{
  <#
      .Synopsis
      Removes a profile directory via API

      .DESCRIPTION
      Removes a profile directory via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER DIRID
      ProfileDirectoryIDs to remove

      .EXAMPLE
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        DIRID        = 49601
      }
      Remove-UMSProfileDirectory @Params
      #Removes profile directory with ID 49601

      .EXAMPLE
      49601, 49603 | Remove-UMSProfileDirectory -Computername 'UMSSERVER'
      #Removes profile directory with ID 49601 and 49603

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
    $DIRID
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

    $UriArray = @($Computername, $TCPPort, $ApiVersion, $DIRID)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/{3}' -f $UriArray

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Method      = 'Delete'
      ContentType = 'application/json'
      Headers     = @{}
    }

    if ($PSCmdlet.ShouldProcess('DIRID: {0}' -f $DIRID))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}