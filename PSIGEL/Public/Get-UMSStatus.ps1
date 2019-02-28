function Get-UMSStatus
{
  [cmdletbinding()]
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
    $WebSession
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/serverstatus' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json'
      Headers          = @{}
      Uri              = $BaseURL
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    $APIObjectColl = Invoke-UMSRestMethodWebSession @Params

    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'RmGuiServerVersion' = [string]$APIObject.rmGuiServerVersion
        'BuildNumber'        = [int]$APIObject.buildNumber
        'ActiveMqVersion'    = [string]$APIObject.activeMQVersion
        'DerbyVersion'       = [string]$APIObject.derbyVersion
        'ServerUuid'         = [string]$APIObject.serverUUID
        'Server'             = [string]$APIObject.server
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}

