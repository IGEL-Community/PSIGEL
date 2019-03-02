function Update-UMSThinclient
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
    [int]
    $Id,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $Name,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $Site,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $Department,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $CostCenter,

    [Parameter(ParameterSetName = 'Set')]
    [ValidateScript( {$_ -match [IPAddress]$_})]
    [String]
    $LastIP,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $Comment,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $AssetId,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $InserviceDate,

    [Parameter(ParameterSetName = 'Set')]
    [ValidateLength(19, 19)]
    [String]
    $SerialNumber
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion, $Id)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients/{3}' -f $UriArray)
  }
  Process
  {
    Switch ($PsCmdlet.ParameterSetName)
    {
      'Set'
      {
        $BodyHashTable = @{}
        if ($Name)
        {
          $BodyHashTable.Add('name', $Name)
        }
        if ($Site)
        {
          $BodyHashTable.Add('site', $Site)
        }
        if ($Department)
        {
          $BodyHashTable.Add('department', $Department)
        }
        if ($CostCenter)
        {
          $BodyHashTable.Add('costCenter', $CostCenter)
        }
        if ($LastIP)
        {
          $BodyHashTable.Add('lastIP', $LastIP)
        }
        if ($Comment)
        {
          $BodyHashTable.Add('comment', $Comment)
        }
        if ($AssetId)
        {
          $BodyHashTable.Add('assetID', $AssetId)
        }
        if ($InserviceDate)
        {
          $BodyHashTable.Add('inserviceDate', $InserviceDate)
        }
        if ($SerialNumber)
        {
          $BodyHashTable.Add('serialNumber', $SerialNumber)
        }
        $Body = ConvertTo-Json $BodyHashTable
        $Params = @{
          WebSession       = $WebSession
          Uri              = $BaseURL
          Body             = $Body
          Method           = 'Put'
          ContentType      = 'application/json'
          Headers          = @{}
          SecurityProtocol = ($SecurityProtocol -join ',')
        }
        if ($PSCmdlet.ShouldProcess(('Id: {0}' -f $Id)))
        {
          $APIObjectColl = Invoke-UMSRestMethodWebSession @Params
        }
        $Result = foreach ($APIObject in $APIObjectColl)
        {
          $Properties = [ordered]@{
            'Message' = [string]('{0}.' -f $APIObject.message)
            'Id'      = [int]$Id
          }
          New-Object psobject -Property $Properties
        }
        $Result
      }
      Default
      {
        throw "Specify at least one property to update!"
      }
    }
  }
  End
  {
  }
}

