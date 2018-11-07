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
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Update-UMSProfileName -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 48170 -Name 'NewProfileName' -Confirm
      #Updates profile name to 'NewProfileName'

      .EXAMPLE
      $UpdateUMSProfileNameParams = @{
          Computername  = 'UMSSERVER'
          ProfileID     = 48170
          Name          = 'NewProfileName'
        }
      Update-UMSProfileName @UpdateUMSProfileNameParams
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
    
    $Body = [ordered]@{
      name = $Name
    } | ConvertTo-Json
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $Computername, $TCPPort, $ApiVersion, $ProfileID
    if ($PSCmdlet.ShouldProcess(('ProfileID: {0}, new name: {1}' -f $ProfileID, $Name)))
    {
      Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -BodyWavy $Body -Method 'Put'
    }
  }
  End
  {
  }
}