function Update-UMSProfileName
{
  <#
      .Synopsis
      Updates a profile name.

      .DESCRIPTION
      Updates a profile name.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ProfileID
      ProfileID of the profile to update name

      .Parameter Name
      New Name of the profile

      .EXAMPLE
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        ProfileID    = 48170
        Name         = 'NewProfileName'
      }
      Update-UMSProfileName @Params
      #Updates profile name to 'NewProfileName'

      .EXAMPLE
      Update-UMSProfileName -Computername 'UMSSERVER' -ProfileID 48170 -Name 'NewProfileName'
      #Updates profile name to 'NewProfileName'
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
    $ProfileID,

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

    $UriArray = @($Computername, $TCPPort, $ApiVersion, $ProfileID)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $UriArray

    $Body = ConvertTo-Json @{
      name = $Name
    }

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Body        = $Body
      Method      = 'Put'
      ContentType = 'application/json'
      Headers     = @{}
    }

    if ($PSCmdlet.ShouldProcess(('ProfileID: {0}, new name: {1}' -f $ProfileID, $Name)))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}