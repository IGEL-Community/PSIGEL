function Get-UMSThinclientDirectoryAssignment
{
  <#
      .Synopsis
      Gets the profile and master profile assignments for the specified thincient directory,
      in order of their application via API

      .DESCRIPTION
      Gets the profile and master profile assignments for the specified thincient directory,
      in order of their application via API

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
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        DIRID        = 772
      }
      Get-UMSThinclientDirectoryAssignment @Params
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
    if ($null -eq $WebSession)
    {
      $WebSession = New-UMSAPICookie -Computername $Computername
    }
    
    $UriArray = @($Computername, $TCPPort, $ApiVersion, $DIRID)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/{3}/assignments/profiles' -f $UriArray

    $Params = @{
      WebSession  = $WebSession
      Method      = 'Get'
      ContentType = 'application/json'
      Headers     = @{}
      Uri         = $Uri
    }
    Invoke-UMSRestMethodWebSession @Params
  }
  End
  {
  }
}