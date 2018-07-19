function Get-UMSThinclientAssignment
{
  <#
      .Synopsis
      Gets the profile and master profile assignments for the specified thin client, in order of their application from Rest API.

      .DESCRIPTION
      Gets the profile and master profile assignments for the specified thin client, in order of their application from Rest API.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCID
      ThinclientID to search for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSThinclientAssignment -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
      Gets the profile and master profile assignments for Thinclient with TCID 2433.

      .EXAMPLE
      2433 | Get-UMSThinclientAssignment -Computername 'UMSSERVER'
      Gets the profile and master profile assignments for Thinclient with TCID 2433.
  #>

  [cmdletbinding()]
  param
  (
    [Parameter( Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0, 65535)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

    $WebSession,

    [Parameter(ValueFromPipeline)]
    [int]
    $TCID = 0
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
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}/assignments/profiles' -f $Computername, $TCPPort, $ApiVersion, $TCID
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get'
  }
  End
  {
  }
}

