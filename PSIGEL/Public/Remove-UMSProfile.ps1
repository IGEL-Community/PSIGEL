function Remove-UMSProfile
{
  <#
      .Synopsis
      Deletes profile.

      .DESCRIPTION
      Deletes profile.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ProfileID
      ProfileID of the thinclient to remove

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Remove-UMSProfile -Computername $Computername -WebSession $WebSession -ProfileID 100
      Removes Profile with ProfileID 100

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      100 | Remove-UMSProfile -Computername $Computername -WebSession $WebSession
      Removes Profile with ProfileID 100
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

    [Parameter(Mandatory, ValueFromPipeline)]
    [int]
    $ProfileID
  )

  Begin
  {
  }
  Process
  {

    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $Computername, $TCPPort, $ApiVersion, $ProfileID

    $ThinclientsJSONCollParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      ContentType = 'application/json'
      Method      = 'Delete'
      WebSession  = $WebSession
    }

    $ThinclientsJSONColl = Invoke-RestMethod @ThinclientsJSONCollParams
    $ThinclientsJSONColl
  }
  End
  {
  }
}

