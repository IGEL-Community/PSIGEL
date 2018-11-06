function Get-UMSThinclientDirectoryAssignment
{
  <#
      .Synopsis
      Gets the profile and master profile assignments for the specified thincient directory, in order of their application via API

      .DESCRIPTION
      Gets the profile and master profile assignments for the specified thincient directory, in order of their application via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER DIRID
      DIRID to get profile assignments for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSThinclientDirectoryAssignment -Computername 'UMSSERVER' -WebSession $WebSession -DIRID 772
      #Gets the profile and master profile assignments for thincient directory 772

      .EXAMPLE
      772, 774 | Get-UMSThinclientDirectoryAssignment -Computername 'UMSSERVER'
      #Gets the profile and master profile assignments for the thincient directories 772 and 774

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
    $Uri = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/{3}/assignments/profiles' -f $Computername,
    $TCPPort, $ApiVersion, $DIRID
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -Uri $Uri -Method 'Get'
  }
  End
  {
  }
}