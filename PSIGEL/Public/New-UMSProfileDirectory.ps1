function New-UMSProfileDirectory
{
  <#
      .Synopsis
      Creates a Profile Directory via API

      .DESCRIPTION
      Creates a Profile Directory via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER Name
      Name of the Profile Directory to create

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      New-UMSProfileDirectory -Computername 'UMSSERVER' -WebSession $WebSession -Name 'NewProfileDir1' -Confirm
      #Creates a Profile Directory with name 'NewProfileDir1'

      .EXAMPLE
      'NewProfileDir1', 'NewProfileDir2' | New-UMSProfileDirectory -Computername 'UMSSERVER'
      #Creates Profile Directories with names 'NewProfileDir1' and 'NewProfileDir2'

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
    Switch ($WebSession)
    {
      $null
      {
        $WebSession = New-UMSAPICookie -Computername $Computername
      }
    }
    $Body = @{
      name = $Name
    } | ConvertTo-Json
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/' -f $Computername, $TCPPort, $ApiVersion
    if ($PSCmdlet.ShouldProcess('Name: {0}' -f $Name))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -BodyWavy $Body -Method 'Put'
    }
  }
  End
  {
  }
}