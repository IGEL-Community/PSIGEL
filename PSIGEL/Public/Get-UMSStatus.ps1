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
    $Json = Invoke-UMSRestMethodWebSession @Params

    $Result = foreach ($item in $Json)
    {
      $Properties = [ordered]@{
        'RmGuiServerVersion' = [string]$item.rmGuiServerVersion
        'BuildNumber'        = [int]$item.buildNumber
        'ActiveMqVersion'    = [string]$item.activeMQVersion
        'DerbyVersion'       = [string]$item.derbyVersion
        'ServerUuid'         = [string]$item.serverUUID
        'Server'             = [string]$item.server
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}

