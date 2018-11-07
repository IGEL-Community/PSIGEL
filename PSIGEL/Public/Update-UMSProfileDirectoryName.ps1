function Update-UMSProfileDirectoryName
{
  <#
      .Synopsis
      Updates a Profile Directory name via API

      .DESCRIPTION
      Updates a Profile Directory name via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER DIRID
      DIRIDs to update name for

      .Parameter Name
      New Name of the directory

      .EXAMPLE
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        DIRID        = 49339
        Name         = 'NewDirName'
      }
      Update-UMSProfileDirectoryName @Params
      #Updates profile directory name to 'NewDirName'

      .EXAMPLE
      49339 | Update-UMSProfileDirectoryName -Computername 'UMSSERVER' -Name 'NewDirName'
      #Updates profile directory name to 'NewDirName'

  #>

  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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
    $DIRID,

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

    $UriArray = @($Computername, $TCPPort, $ApiVersion, $DIRID)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/{3}' -f $UriArray

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

    if ($PSCmdlet.ShouldProcess(('DIRID: {0}, new name: {1}' -f $DIRID, $Name)))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}