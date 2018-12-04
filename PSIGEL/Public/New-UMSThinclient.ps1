function New-UMSThinclient
{
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

    [Parameter(Mandatory)]
    [ValidatePattern('^([0-9a-f]{12})$')]
    [String]
    $Mac,

    [Parameter(Mandatory)]
    [int]
    $FirmwareID,

    [String]
    $Name,

    [int]
    $ParentID = -1,

    [String]
    $Site,

    [String]
    $Department,

    [String]
    $CostCenter,

    [ValidateScript( {$_ -match [IPAddress]$_})]
    [String]
    $LastIP,

    [String]
    $Comment,

    [String]
    $AssetID,

    [String]
    $InserviceDate,

    [ValidateLength(19, 19)]
    [String]
    $SerialNumber
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
    $Uri = 'https://{0}:{1}/umsapi/v{2}/thinclients/' -f $UriArray
    $Body = ConvertTo-Json @{
      mac           = $Mac
      firmwareID    = $FirmwareID
      name          = $Name
      parentID      = $ParentID
      site          = $Site
      department    = $Department
      costCenter    = $CostCenter
      lastIP        = $LastIP
      comment       = $Comment
      assetID       = $AssetID
      inserviceDate = $InserviceDate
      serialNumber  = $SerialNumber
    }

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Body        = $Body
      Method      = 'Put'
      ContentType = 'application/json'
      Headers     = @{}
    }

    if ($PSCmdlet.ShouldProcess('MAC-Address: {0}' -f $Mac))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}

