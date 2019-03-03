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
    $Facet = 'short',

    [Parameter(ValueFromPipeline, ParameterSetName = 'Id')]
    [Int]
    $Id
  )
  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients' -f $UriArray)
    $FunctionString = New-UMSFunctionString -Facet $Facet
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
        $APIObjectColl = (Invoke-UMSRestMethodWebSession @Params).SyncRoot
      }
      'Id'
      {
        $Params.Add('Uri', ('{0}/{1}{2}' -f $BaseURL, $Id, $FunctionString))
        $APIObjectColl = Invoke-UMSRestMethodWebSession @Params
      }
    }

    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'Id'         = [int]$APIObject.id
        'ObjectType' = [string]$APIObject.objectType
        'UnitId'     = [string]$APIObject.unitID
        'Mac'        = [string]$APIObject.mac
        'Name'       = [string]$APIObject.name
        'ParentId'   = [int]$APIObject.parentID
        'FirmwareId' = [int]$APIObject.firmwareID
        'LastIp'     = [string]$APIObject.lastIP
        'MovedToBin' = [System.Convert]::ToBoolean($APIObject.movedToBin)
      }
      switch ($Facet)
      {
        online
        {
          $Properties += [ordered]@{
            'Online' = [System.Convert]::ToBoolean($APIObject.online)
          }
        }
        shadow
        {
          $Properties += [ordered]@{
            'ShadowSecret' = $APIObject.shadowSecret
          }
        }
        details
        {
          $Properties += [ordered]@{
            'NetworkName'               = [string]$APIObject.networkName
            'Comment'                   = [string]$APIObject.comment
            'ProductId'                 = [string]$APIObject.productId
            'CpuSpeed'                  = [int]$APIObject.cpuSpeed
            'CpuType'                   = [string]$APIObject.cpuType
            'DeviceType'                = [string]$APIObject.deviceType
            'DeviceSerialNumber'        = [string]$APIObject.deviceSerialNumber
            'OsType'                    = [string]$APIObject.osType
            'FlashSize'                 = [int]$APIObject.flashSize
            'MemorySize'                = [int]$APIObject.memorySize
            'NetworkSpeed'              = [int]$APIObject.networkSpeed
            'GraphicsChipset0'          = [string]$APIObject.graphicsChipset0
            'GraphicsChipset1'          = [string]$APIObject.graphicsChipset1
            'MonitorVendor1'            = [string]$APIObject.monitorVendor1
            'MonitorModel1'             = [string]$APIObject.monitorModel1
            'MonitorSerialnumber1'      = [string]$APIObject.monitorSerialnumber1
            'MonitorSize1'              = [int]$APIObject.monitorSize1
            'MonitorNativeResolution1'  = [string]$APIObject.monitorNativeResolution1
            'Monitor1YearOfManufacture' = [int]$APIObject.monitor1YearOfManufacture
            'Monitor1WeekOfManufacture' = [int]$APIObject.monitor1WeekOfManufacture
            'MonitorVendor2'            = [string]$APIObject.monitorVendor2
            'MonitorModel2'             = [string]$APIObject.monitorModel2
            'MonitorSerialnumber2'      = [string]$APIObject.monitorSerialnumber2
            'MonitorSize2'              = [int]$APIObject.monitorSize2
            'MonitorNativeResolution2'  = [string]$APIObject.monitorNativeResolution2
            'Monitor2YearOfManufacture' = [int]$APIObject.monitor2YearOfManufacture
            'Monitor2WeekOfManufacture' = [int]$APIObject.monitor2WeekOfManufacture
            'BiosVendor'                = [string]$APIObject.biosVendor
            'BiosVersion'               = [string]$APIObject.biosVersion
            'BiosDate'                  = [datetime]$APIObject.biosDate
            'TotalUsagetime'            = [int]$APIObject.totalUsagetime
            'TotalUptime'               = [int]$APIObject.totalUptime
            'LastBoottime'              = [datetime]$APIObject.lastBoottime
            'BatteryLevel'              = [int]$APIObject.batteryLevel
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