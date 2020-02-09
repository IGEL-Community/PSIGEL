<#
Integration Tests Config
#>

@{

  Computername     = 'localhost'
  TCPPort          = 9443
  CredPath         = 'C:\Credentials\UMSRmdb.cred'
  SecurityProtocol = 'Tls12'
  ProfileRootDirId = 527 # Profiles->PSIGEL
  DeviceRootDirId  = 502 # Devices -> PSIGEL
  Tests            = [ordered]@{
    'GetUMSFirmware' = @{
      1 = @{
        Product      = 'IGEL OS 11'
        Version      = '11.3.100.1'
        FirmwareType = 'LX'
      }
      2 = @{
        Product      = 'IGEL OS 11'
        Version      = '11.3.110.1'
        FirmwareType = 'LX'
      }
    }
    'GetUMSProfile'  = @{
      529 = @{
        FirmwareId        = 1
        IsMasterProfile   = 'False'
        OverridesSessions = 'False'
        Name              = 'PRO_RDP_Session01'
        ParentId          = 528
        MovedToBin        = 'False'
        ObjectType        = 'profile'
      }
      532 = @{
        FirmwareId        = 1
        IsMasterProfile   = 'False'
        OverridesSessions = 'False'
        Name              = 'PRO_Terminal_LocalTerminal'
        ParentId          = 531
        MovedToBin        = 'False'
        ObjectType        = 'profile'
      }
      535 = @{
        FirmwareId        = 2
        IsMasterProfile   = 'False'
        OverridesSessions = 'False'
        Name              = 'PRO_LNG_DE'
        ParentId          = 533
        MovedToBin        = 'False'
        ObjectType        = 'profile'
      }
      537 = @{
        FirmwareId        = 2
        IsMasterProfile   = 'False'
        OverridesSessions = 'False'
        Name              = 'PRO_NW_LAN'
        ParentId          = 533
        MovedToBin        = 'False'
        ObjectType        = 'profile'
      }
      538 = @{
        FirmwareId        = 2
        IsMasterProfile   = 'False'
        OverridesSessions = 'False'
        Name              = 'PRO_NW_WLAN'
        ParentId          = 533
        MovedToBin        = 'False'
        ObjectType        = 'profile'
      }
      540 = @{
        FirmwareId        = 1
        IsMasterProfile   = 'False'
        OverridesSessions = 'False'
        Name              = 'PRO_PW_Root'
        ParentId          = 539
        MovedToBin        = 'False'
        ObjectType        = 'profile'
      }
      542 = @{
        FirmwareId        = 1
        IsMasterProfile   = 'False'
        OverridesSessions = 'False'
        Name              = 'PRO_TZ_CET'
        ParentId          = 541
        MovedToBin        = 'False'
        ObjectType        = 'profile'
      }
    }
    <#
    3  = 'Get-UMSProfileDirectory'
    4  = 'Get-UMSProfileAssignment'
    5  = 'Get-UMSStatus'
    6  = 'Get-UMSDevice'
    7  = 'Get-UMSDeviceAssignment'
    8  = 'Get-UMSDeviceDirectory'
    9  = 'Get-UMSDeviceDirectoryAssignment'
    10 = 'Get-UMSDirectoryRecursive'
    11 = 'Start-UMSDevice'
    12 = 'Send-UMSDeviceSetting'
    13 = 'Restart-UMSDevice'
    14 = 'Stop-UMSDevice'
    15 = 'Update-UMSProfile'
    16 = 'Update-UMSProfileDirectory'
    17 = 'Update-UMSDevice'
    18 = 'Update-UMSDeviceDirectory'
    19 = 'Move-UMSProfile'
    20 = 'Move-UMSProfileDirectory'
    21 = 'Move-UMSDevice'
    22 = 'Move-UMSDeviceDirectory'
    23 = 'New-UMSProfileAssignment'
    24 = 'New-UMSProfileDirectory'
    25 = 'New-UMSDevice'
    26 = 'New-UMSDeviceDirectory'
    27 = 'Remove-UMSProfileAssignment'
    28 = 'Remove-UMSProfile'
    29 = 'Remove-UMSProfileDirectory'
    30 = 'Remove-UMSDevice'
    31 = 'Remove-UMSDeviceDirectory'
    32 = 'Reset-UMSDevice'
    #>
  }


}