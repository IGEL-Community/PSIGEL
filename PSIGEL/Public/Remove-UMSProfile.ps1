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
      Remove-UMSProfile -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 48170
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
    
    $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $Computername, $TCPPort, $ApiVersion, $ProfileID
    if ($PSCmdlet.ShouldProcess('ProfileID: {0}' -f $ProfileID))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -Uri $Uri -Method 'Delete'
    }
  }
  End
  {
  }
}

