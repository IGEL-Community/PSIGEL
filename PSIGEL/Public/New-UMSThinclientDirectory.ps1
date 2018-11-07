function New-UMSThinclientDirectory
{
  <#
      .Synopsis
      Creates a Thinclient Directory via API

      .DESCRIPTION
      Creates a Thinclient Directory via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER Name
      Name of the Thinclient Directory to create

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      New-UMSThinclientDirectory -Computername 'UMSSERVER' -WebSession $WebSession -Name 'NewTcDir1' -Confirm
      #Creates a Thinclient Directory with name 'NewTcDir1'

      .EXAMPLE
      'NewTcDir1', 'NewTcDir2' | New-UMSThinclientDirectory -Computername 'UMSSERVER'
      #Creates Thinclient Directories with names 'NewTcDir1' and 'NewTcDir2'

  #>

  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
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
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/' -f $Computername, $TCPPort, $ApiVersion
    if ($PSCmdlet.ShouldProcess('Name: {0}' -f $Name))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -BodyWavy $Body -Method 'Put'
    }
  }
  End
  {
  }
}