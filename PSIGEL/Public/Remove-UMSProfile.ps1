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
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        ProfileID    = 48170
      }
      Remove-UMSProfile @Params
      #Removes Profile with ProfileID 48170

      .EXAMPLE
      48170 | Remove-UMSProfile -Computername 'UMSSERVER'
      #Removes Profile with ProfileID 48170
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
    $ProfileID
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

    $UriArray = @($Computername, $TCPPort, $ApiVersion, $ProfileID)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $UriArray

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Method      = 'Delete'
      ContentType = 'application/json'
      Headers     = @{}
    }

    if ($PSCmdlet.ShouldProcess('ProfileID: {0}' -f $ProfileID))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}

