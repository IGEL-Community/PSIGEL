function New-UMSThinclientDirectory
{
  <#
      .Synopsis
      Creates a Thinclient Directory via API

      .DESCRIPTION
      Creates a Thinclient Directory via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER Name
      Name of the Thinclient Directory to create

      .EXAMPLE
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
        Name         = 'NewTcDir1'
      }
      New-UMSThinclientDirectory @Params
      #Creates Thinclient Directory with name 'NewTcDir1'

      .EXAMPLE
      'NewTcDir1', 'NewTcDir2' | New-UMSThinclientDirectory -Computername 'UMSSERVER'
      #Creates Thinclient Directories with names 'NewTcDir1' and 'NewTcDir2'

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
    $Uri = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/' -f $UriArray
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