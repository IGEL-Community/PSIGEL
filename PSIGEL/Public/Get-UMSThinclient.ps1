function Get-UMSThinclient
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

    [ValidateSet('short', 'details', 'online', 'shadow')]
    [String]
    $Facets = 'short',

    [Parameter(ValueFromPipeline, ParameterSetName = 'ID')]
    [int]
    $TCID
  )
  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients' -f $UriArray)
    $FunctionString = Get-UMSFunctionString -Facets $Facets

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
        $Params.Add('Uri', ('{0}{1}' -f $BaseURL, $FunctionString))
        $JSON = (Invoke-UMSRestMethodWebSession @Params).SyncRoot
      }
      'ID'
      {
        $Params.Add('Uri', ('{0}/{1}{2}' -f $BaseURL, $TCID, $FunctionString))
        $JSON = Invoke-UMSRestMethodWebSession @Params
      }
    }

    $Result = foreach ($item in $JSON)
    {
      $Properties = [ordered]@{
        'id'         = [int]$item.id
        'objectType' = [string]$item.objectType
        'unitID'     = [string]$item.unitID
        'mac'        = [string]$item.mac
        'name'       = [string]$item.name
        'parentID'   = [int]$item.parentID
        'firmwareID' = [int]$item.firmwareID
        'lastIP'     = [string]$item.lastIP
        'movedToBin' = [bool]$item.movedToBin #False
      }
      switch ($Facets)
      {
        online
        {
          $Properties += [ordered]@{
            'online' = [bool]$item.online
          }
        }
        shadow
        {
          $Properties += [ordered]@{
            'shadowSecret' = $item.shadowSecret
          }
        }
        details
        {
          $Properties += [ordered]@{
            'networkName'               = [string]$item.networkName
            'comment'                   = [string]$item.comment
            'productId'                 = [string]$item.productId
            'cpuSpeed'                  = [int]$item.cpuSpeed
            'cpuType'                   = [string]$item.cpuType
            'deviceType'                = [string]$item.deviceType
            'deviceSerialNumber'        = [string]$item.deviceSerialNumber
            'osType'                    = [string]$item.osType
            'flashSize'                 = [int]$item.flashSize
            'memorySize'                = [int]$item.memorySize
            'networkSpeed'              = [int]$item.networkSpeed
            'graphicsChipset0'          = [string]$item.graphicsChipset0
            'graphicsChipset1'          = [string]$item.graphicsChipset1
            'monitorVendor1'            = [string]$item.monitorVendor1
            'monitorModel1'             = [string]$item.monitorModel1
            'monitorSerialnumber1'      = [string]$item.monitorSerialnumber1
            'monitorSize1'              = [int]$item.monitorSize1
            'monitorNativeResolution1'  = [string]$item.monitorNativeResolution1
            'monitor1YearOfManufacture' = [int]$item.monitor1YearOfManufacture
            'monitor1WeekOfManufacture' = [int]$item.monitor1WeekOfManufacture
            'monitorVendor2'            = [string]$item.monitorVendor2
            'monitorModel2'             = [string]$item.monitorModel2
            'monitorSerialnumber2'      = [string]$item.monitorSerialnumber2
            'monitorSize2'              = [int]$item.monitorSize2
            'monitorNativeResolution2'  = [string]$item.monitorNativeResolution2
            'monitor2YearOfManufacture' = [int]$item.monitor2YearOfManufacture
            'monitor2WeekOfManufacture' = [int]$item.monitor2WeekOfManufacture
            'biosVendor'                = [string]$item.biosVendor
            'biosVersion'               = [string]$item.biosVersion
            'biosDate'                  = [datetime]$item.biosDate
            'totalUsagetime'            = [int]$item.totalUsagetime
            'totalUptime'               = [int]$item.totalUptime
            'lastBoottime'              = [datetime]$item.lastBoottime
            'batteryLevel'              = [int]$item.batteryLevel
          }
        }
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}