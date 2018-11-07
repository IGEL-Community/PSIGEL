function Update-UMSThinclientDirectoryName
{
  <#
      .Synopsis
      Updates a Thin Client Directory name via API

      .DESCRIPTION
      Updates a Thin Client Directory name via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER DIRID
      DIRIDs to update name for

      .Parameter Name
      New Name of the directory

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Update-UMSThinclientDirectoryName -Computername 'UMSSERVER' -WebSession $WebSession -DIRID 49289 -Name 'NewDirName'
      #Updates thinclient directory name to 'NewDirName'

      .EXAMPLE
      49289 | Update-UMSThinclientDirectoryName -Computername 'UMSSERVER' -Name 'NewDirName'
      #Updates thinclient directory name to 'NewDirName'

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
    $DIRID,

    [Parameter(Mandatory)]
    [String]
    $Name
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
      name = $Name
    } | ConvertTo-Json
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/{3}' -f $Computername, $TCPPort, $ApiVersion, $DIRID
    if ($PSCmdlet.ShouldProcess(('DIRID: {0}, new name: {1}' -f $DIRID, $Name)))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -BodyWavy $Body -Method 'Put'
    }
  }
  End
  {
  }
}