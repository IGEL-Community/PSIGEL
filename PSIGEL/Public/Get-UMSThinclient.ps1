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

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Id')]
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
        'Id'         = [Int]$APIObject.id
        'ObjectType' = [String]$APIObject.objectType
        'UnitId'     = [String]$APIObject.unitID
        'Mac'        = [String]$APIObject.mac
        'Name'       = [String]$APIObject.name
        'ParentId'   = [Int]$APIObject.parentID
        'FirmwareId' = [Int]$APIObject.firmwareID
        'LastIp'     = [String]$APIObject.lastIP
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
            'NetworkName'               = [String]$APIObject.networkName
            'Comment'                   = [String]$APIObject.comment
            'ProductId'                 = [String]$APIObject.productId
            'CpuSpeed'                  = [Int]$APIObject.cpuSpeed
            'CpuType'                   = [String]$APIObject.cpuType
            'DeviceType'                = [String]$APIObject.deviceType
            'DeviceSerialNumber'        = [String]$APIObject.deviceSerialNumber
            'OsType'                    = [String]$APIObject.osType
            'FlashSize'                 = [Int]$APIObject.flashSize
            'MemorySize'                = [Int]$APIObject.memorySize
            'NetworkSpeed'              = [Int]$APIObject.networkSpeed
            'GraphicsChipset0'          = [String]$APIObject.graphicsChipset0
            'GraphicsChipset1'          = [String]$APIObject.graphicsChipset1
            'MonitorVendor1'            = [String]$APIObject.monitorVendor1
            'MonitorModel1'             = [String]$APIObject.monitorModel1
            'MonitorSerialnumber1'      = [String]$APIObject.monitorSerialnumber1
            'MonitorSize1'              = [Int]$APIObject.monitorSize1
            'MonitorNativeResolution1'  = [String]$APIObject.monitorNativeResolution1
            'Monitor1YearOfManufacture' = [Int]$APIObject.monitor1YearOfManufacture
            'Monitor1WeekOfManufacture' = [Int]$APIObject.monitor1WeekOfManufacture
            'MonitorVendor2'            = [String]$APIObject.monitorVendor2
            'MonitorModel2'             = [String]$APIObject.monitorModel2
            'MonitorSerialnumber2'      = [String]$APIObject.monitorSerialnumber2
            'MonitorSize2'              = [Int]$APIObject.monitorSize2
            'MonitorNativeResolution2'  = [String]$APIObject.monitorNativeResolution2
            'Monitor2YearOfManufacture' = [Int]$APIObject.monitor2YearOfManufacture
            'Monitor2WeekOfManufacture' = [Int]$APIObject.monitor2WeekOfManufacture
            'BiosVendor'                = [String]$APIObject.biosVendor
            'BiosVersion'               = [String]$APIObject.biosVersion
            'TotalUsagetime'            = [Int64]$APIObject.totalUsagetime
            'TotalUptime'               = [Int64]$APIObject.totalUptime
            'BatteryLevel'              = [Int]$APIObject.batteryLevel
          }
          if ($APIObject.lastBoottime)
          {
            $Properties.Add('LastBootTime', [datetime]$APIObject.lastBoottime)
          }
          else
          {
            $Properties.Add('LastBootTime', '')
          }
          if ($APIObject.biosDate)
          {
            $Properties.Add('BiosDate', [datetime]$APIObject.biosDate)
          }
          else
          {
            $Properties.Add('BiosDate', '')
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