function Get-UMSProfile
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
    $ProfileID = 0
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/profiles' -f $UriArray)
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
        $Json = (Invoke-UMSRestMethodWebSession @Params).SyncRoot
      }
      'ID'
      {
        $Params.Add('Uri', ('{0}/{1}' -f $BaseURL, $ProfileID))
        $Json = Invoke-UMSRestMethodWebSession @Params
      }
    }
    $Result = foreach ($item in $Json)
    {
      $Properties = [ordered]@{
        'firmwareID'        = [int]$item.firmwareID
        'isMasterProfile'   = [System.Convert]::ToBoolean($item.isMasterProfile)
        'overridesSessions' = [System.Convert]::ToBoolean($item.overridesSessions)
        'id'                = [int]$item.id
        'name'              = [string]$item.name
        'parentID'          = [int]$item.parentID
        'movedToBin'        = [System.Convert]::ToBoolean($item.movedToBin)
        'objectType'        = [string]$item.objectType
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}

