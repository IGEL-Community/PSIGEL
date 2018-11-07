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
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        Name         = 'NewProfileDir1'
      }
      New-UMSProfileDirectory @Params
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
    if ($null -eq $WebSession)
    {
      $WebSession = New-UMSAPICookie -Computername $Computername
    }

    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/' -f $UriArray
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

    if ($PSCmdlet.ShouldProcess('Name: {0}' -f $Name))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}