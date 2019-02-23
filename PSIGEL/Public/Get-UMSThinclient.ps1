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
          $Properties.Add('online', [bool]$item.online)
        }
        shadow
        {
          $Properties.Add('shadowSecret', $item.shadowSecret)
        }
        details
        {
          $Properties.Add('networkName', [string]$item.networkName) #V11-01
          $Properties.Add('comment', [string]$item.comment) #Kommentar: 20.02.2019 15:49:20
          $Properties.Add('productId', [string]$item.productId) #UC1-LX
          $Properties.Add('cpuSpeed', [int]$item.cpuSpeed) #1608
          $Properties.Add('cpuType', [string]$item.cpuType) #Intel(R) Core(TM) i7-7Y75 CPU @ 1.30GHz
          $Properties.Add('deviceType', [string]$item.deviceType) #Legacy x86 system
          $Properties.Add('deviceSerialNumber', [string]$item.deviceSerialNumber) #[string] 0
          $Properties.Add('osType', [string]$item.osType) #IGEL Linux 11 (Kernel Version 4.18.20)
          $Properties.Add('flashSize', [int]$item.flashSize) #1985
          $Properties.Add('memorySize', [int]$item.memorySize) #1990
          $Properties.Add('networkSpeed', [int]$item.networkSpeed) #100
          $Properties.Add('graphicsChipset0', [string]$item.graphicsChipset0) #VMware Inc. Abstract VGA II Adapter
          $Properties.Add('graphicsChipset1', [string]$item.graphicsChipset1)
          $Properties.Add('monitorVendor1', [string]$item.monitorVendor1)
          $Properties.Add('monitorModel1', [string]$item.monitorModel1)
          $Properties.Add('monitorSerialnumber1', [string]$item.monitorSerialnumber1)
          $Properties.Add('monitorSize1', [int]$item.monitorSize1) #0,0
          $Properties.Add('monitorNativeResolution1', [string]$item.monitorNativeResolution1)
          $Properties.Add('monitor1YearOfManufacture', [int]$item.monitor1YearOfManufacture)
          $Properties.Add('monitor1WeekOfManufacture', [int]$item.monitor1WeekOfManufacture)
          $Properties.Add('monitorVendor2', [string]$item.monitorVendor2)
          $Properties.Add('monitorModel2', [string]$item.monitorModel2)
          $Properties.Add('monitorSerialnumber2', [string]$item.monitorSerialnumber2)
          $Properties.Add('monitorSize2', [int]$item.monitorSize2) #0,0
          $Properties.Add('monitorNativeResolution2', [string]$item.monitorNativeResolution2)
          $Properties.Add('monitor2YearOfManufacture', [int]$item.monitor2YearOfManufacture)
          $Properties.Add('monitor2WeekOfManufacture', [int]$item.monitor2WeekOfManufacture)
          $Properties.Add('biosVendor', [string]$item.biosVendor) # innotek GmbH
          $Properties.Add('biosVersion', [string]$item.biosVersion) # VirtualBox
          $Properties.Add('biosDate', [datetime]$item.biosDate) # 12/01/2006
          $Properties.Add('totalUsagetime', [int]$item.totalUsagetime) # 5433000
          $Properties.Add('totalUptime', [int]$item.totalUptime) # 5472000
          $Properties.Add('lastBoottime', [datetime]$item.lastBoottime) # 2019-02-20 14:19
          $Properties.Add('batteryLevel', [int]$item.batteryLevel) # 97
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