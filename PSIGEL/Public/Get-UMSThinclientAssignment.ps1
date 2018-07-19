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
      API Version to use (2 or 3, Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCID
      ThinclientID to search for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSThinclientAssignment -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433 | Out-GridView
      Gets the profile and master profile assignments for Thinclient with TCID 2433.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      2433 | Get-UMSThinclientAssignment -Computername 'UMSSERVER' -WebSession $WebSession
      Gets the profile and master profile assignments for Thinclient with TCID 2433.
  #>

  [cmdletbinding()]
  param
  (
    [Parameter( Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0,49151)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

    [Parameter(Mandatory)]
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

    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}/assignments/profiles' -f $Computername, $TCPPort, $ApiVersion, $TCID


    $ThinclientsJSONCollParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      ContentType = 'application/json; charset=utf-8'
      Method      = 'Get'
      WebSession  = $WebSession
    }

    $ThinclientsJSONColl = Invoke-RestMethod @ThinclientsJSONCollParams
    $ThinclientsJSONColl

  }
  End
  {
  }
}

