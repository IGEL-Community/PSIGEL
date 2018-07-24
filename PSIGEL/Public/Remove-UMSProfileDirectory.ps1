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
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Remove-UMSProfileDirectory -Computername 'UMSSERVER' -WebSession $WebSession -DIRID 49601
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
    Switch ($WebSession)
    {
      $null
      {
        $WebSession = New-UMSAPICookie -Computername $Computername
      }
    }
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/{3}' -f $Computername, $TCPPort, $ApiVersion, $DIRID
    if ($PSCmdlet.ShouldProcess('DIRID: {0}' -f $DIRID))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Delete'
    }
  }
  End
  {
  }
}