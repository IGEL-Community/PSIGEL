function Update-UMSDevice
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
    [Int]
    $Id,

    [Parameter(ParameterSetName = 'Set')]
    [ValidateLength(1, 15)]
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
    [ValidateScript( { $_ -match [IPAddress]$_ })]
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
    [ValidateLength(18, 18)]
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
    Switch ($PsCmdlet.ParameterSetName)
    {
      'Set'
      {
        $BodyHashTable = @{ }
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
          Uri              = ('{0}/{1}' -f $BaseURL, $Id)
          Body             = $Body
          Method           = 'Put'
          ContentType      = 'application/json'
          Headers          = @{ }
          SecurityProtocol = ($SecurityProtocol -join ',')
        }
        if ($PSCmdlet.ShouldProcess(('Id: {0}' -f $Id)))
        {
          $APIObjectColl = Invoke-UMSRestMethod @Params
        }
        $Result = foreach ($APIObject in $APIObjectColl)
        {
          $Properties = [ordered]@{
            'Message' = [String]('{0}.' -f $APIObject.message)
            'Id'      = [Int]$Id
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

