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

    [ValidateSet('Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol = 'Tls12',

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidatePattern('^([0-9a-f]{12})$')]
    [String]
    $Mac,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [int]
    $FirmwareId,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $Name,

    [Parameter(ValueFromPipelineByPropertyName)]
    [int]
    $ParentId = -1,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $Site,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $Department,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $CostCenter,

    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript( {$_ -match [IPAddress]$_})]
    [String]
    $LastIP,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $Comment,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $AssetId,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $InserviceDate,

    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateLength(19, 19)]
    [String]
    $SerialNumber
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients' -f $UriArray)
  }
  Process
  {
    $Body = ConvertTo-Json @{
      mac           = $Mac
      firmwareID    = $FirmwareId.ToString()
      name          = $Name
      parentID      = $ParentId.ToString()
      site          = $Site
      department    = $Department
      costCenter    = $CostCenter
      lastIP        = $LastIP
      comment       = $Comment
      assetID       = $AssetId
      inserviceDate = $InserviceDate
      serialNumber  = $SerialNumber
    }
    $Params = @{
      WebSession       = $WebSession
      Uri              = $BaseURL
      Body             = $Body
      Method           = 'Put'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    if ($PSCmdlet.ShouldProcess('MAC: {0}' -f $Mac))
    {
      $APIObjectColl = Invoke-UMSRestMethodWebSession @Params
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'Message'  = [string]$APIObject.message
        'Id'       = [int]$APIObject.id
        'Name'     = [string]$APIObject.name
        'ParentId' = [int]$APIObject.parentID
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}

