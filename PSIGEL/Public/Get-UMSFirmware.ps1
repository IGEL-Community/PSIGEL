function Get-UMSFirmware
{
  [CmdletBinding(DefaultParameterSetName = 'All')]
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

    [Parameter(ValueFromPipeline, ParameterSetName = 'ID')]
    [int]
    $FirmwareID
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/firmwares' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    Switch ($PsCmdlet.ParameterSetName)
    {
      'All'
      {
        $Params.Add('Uri', ('{0}' -f $BaseURL))
        $Json = (Invoke-UMSRestMethodWebSession @Params).FwResource
      }
      'ID'
      {
        $Params.Add('Uri', ('{0}/{1}' -f $BaseURL, $FirmwareID))
        $Json = Invoke-UMSRestMethodWebSession @Params
      }
    }
    $Result = foreach ($item in $Json)
    {
      $Properties = [ordered]@{
        'id'           = [int]$item.id
        'product'      = [string]$item.product
        'version'      = [string]$item.version
        'firmwareType' = [string]$item.firmwareType
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}