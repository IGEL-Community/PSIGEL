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

    [Parameter(ValueFromPipeline, ParameterSetName = 'Id')]
    [int]
    $Id
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
        $Json = (Invoke-UMSRestMethodWebSession @Params).SyncRoot
      }
      'Id'
      {
        $Params.Add('Uri', ('{0}/{1}{2}' -f $BaseURL, $Id, $FunctionString))
        $Json = Invoke-UMSRestMethodWebSession @Params
      }
    }

    $Result = foreach ($item in $Json)
    {
      $Properties = [ordered]@{
        'Id'         = [int]$item.id
        'ObjectType' = [string]$item.objectType
        'UnitId'     = [string]$item.unitID
        'Mac'        = [string]$item.mac
        'Name'       = [string]$item.name
        'ParentId'   = [int]$item.parentID
        'FirmwareId' = [int]$item.firmwareID
        'LastIp'     = [string]$item.lastIP
        'MovedToBin' = [System.Convert]::ToBoolean($item.movedToBin)
      }
      switch ($Facets)
      {
        online
        {
          $Properties += [ordered]@{
            'Online' = [System.Convert]::ToBoolean($item.online)
          }
        }
        shadow
        {
          $Properties += [ordered]@{
            'ShadowSecret' = $item.shadowSecret
          }
        }
        details
        {
          $Properties += [ordered]@{
            'NetworkName'               = [string]$item.networkName
            'Comment'                   = [string]$item.comment
            'ProductId'                 = [string]$item.productId
            'CpuSpeed'                  = [int]$item.cpuSpeed
            'CpuType'                   = [string]$item.cpuType
            'DeviceType'                = [string]$item.deviceType
            'DeviceSerialNumber'        = [string]$item.deviceSerialNumber
            'OsType'                    = [string]$item.osType
            'FlashSize'                 = [int]$item.flashSize
            'MemorySize'                = [int]$item.memorySize
            'NetworkSpeed'              = [int]$item.networkSpeed
            'GraphicsChipset0'          = [string]$item.graphicsChipset0
            'GraphicsChipset1'          = [string]$item.graphicsChipset1
            'MonitorVendor1'            = [string]$item.monitorVendor1
            'MonitorModel1'             = [string]$item.monitorModel1
            'MonitorSerialnumber1'      = [string]$item.monitorSerialnumber1
            'MonitorSize1'              = [int]$item.monitorSize1
            'MonitorNativeResolution1'  = [string]$item.monitorNativeResolution1
            'Monitor1YearOfManufacture' = [int]$item.monitor1YearOfManufacture
            'Monitor1WeekOfManufacture' = [int]$item.monitor1WeekOfManufacture
            'MonitorVendor2'            = [string]$item.monitorVendor2
            'MonitorModel2'             = [string]$item.monitorModel2
            'MonitorSerialnumber2'      = [string]$item.monitorSerialnumber2
            'MonitorSize2'              = [int]$item.monitorSize2
            'MonitorNativeResolution2'  = [string]$item.monitorNativeResolution2
            'Monitor2YearOfManufacture' = [int]$item.monitor2YearOfManufacture
            'Monitor2WeekOfManufacture' = [int]$item.monitor2WeekOfManufacture
            'BiosVendor'                = [string]$item.biosVendor
            'BiosVersion'               = [string]$item.biosVersion
            'BiosDate'                  = [datetime]$item.biosDate
            'TotalUsagetime'            = [int]$item.totalUsagetime
            'TotalUptime'               = [int]$item.totalUptime
            'LastBoottime'              = [datetime]$item.lastBoottime
            'BatteryLevel'              = [int]$item.batteryLevel
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