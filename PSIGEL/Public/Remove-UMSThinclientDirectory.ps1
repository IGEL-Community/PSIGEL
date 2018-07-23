function Remove-UMSThinclientDirectory
{
  <#
      .Synopsis
      Removes a thinclient directory via API

      .DESCRIPTION
      Removes a thinclient directory via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER DIRID
      ThinclientDirectoryIDs to remove

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Remove-UMSThinclientDirectory -Computername 'UMSSERVER' -WebSession $WebSession -DIRID 49289
      #Removes thinclient directory with ID 49289

      .EXAMPLE
      49289, 49260 | Remove-UMSThinclientDirectory -Computername 'UMSSERVER'
      #Removes thinclient directory with ID 49289 and 49260

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
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/{3}' -f $Computername, $TCPPort, $ApiVersion, $DIRID
    if ($PSCmdlet.ShouldProcess('DIRID: {0}' -f $DIRID))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Delete'
    }
  }
  End
  {
  }
}