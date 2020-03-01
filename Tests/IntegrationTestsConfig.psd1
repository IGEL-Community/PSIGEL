<#
Integration Tests Config
#>

@{

  Computername     = 'igelrmserver'
  TCPPort          = 9443
  CredPath         = 'C:\Credentials\UMSRmdb.cred'
  SecurityProtocol = 'Tls12'
  ProfileRootDirId = 527 # Profiles/PSIGEL
  DeviceRootDirId  = 502 # Devices/PSIGEL

  Tests            = @(
    @{
      Function = 'Get-UMSStatus'
      Expected = @{
        RmGuiServerVersion = '6.3.130'
        BuildNumber        = 44584
        ActiveMqVersion    = '5.7.0'
        DerbyVersion       = '10.12.1.1'
        ServerUuid         = 'f30fb3a2-37d4-4cbb-b884-4f4060d3160e'
        Server             = 'igelrmserver:8443'
      }
      Options  = @{
        ExcludedPaths = ''
      }
    }
    @{
      Function = 'New-UMSDeviceDirectory'
      Params1  = @{
        Name = 'QA'
      }
      Expected = @{
        Message = 'Directory successfully inserted.'
        Id      = 593
        Name    = 'QA'
      }
      Options  = @{
        #ExcludedPaths = 'Id'
      }
    }
    @{
      Function = 'New-UMSDevice'
      Params1  = @{
        Mac        = '0A0000000007'
        Name       = 'A-QA-007'
        FirmwareId = 1
        ParentId   = -1
      }
      Params2  = @{
        Mac        = '0A0000000008'
        Name       = 'A-QA-008'
        FirmwareId = 1
        ParentId   = -1
      }
      Expected = @(
        @{
          Mac      = '0A0000000007'
          Message  = 'Device successfully inserted.'
          Id       = 594
          Name     = 'A-QA-007'
          ParentId = -1
        }
        @{
          Mac      = '0A0000000008'
          Message  = 'Device successfully inserted.'
          Id       = 595
          Name     = 'A-QA-008'
          ParentId = - 1
        }
      )
      Options  = @{
        #ExcludedPaths = 'Id'
      }
    }
    @{
      Function = 'New-UMSProfileDirectory'
      Params1  = @{
        Name = 'Devices'
      }
      Expected = @{
        Message = 'Directory successfully inserted.'
        Id      = 596
        Name    = 'Devices'
      }
      Options  = @{
        #ExcludedPaths = 'Id'
      }
    }
    @{
      Function = 'Get-UMSFirmware'
      Expected = @(
        @{
          Id           = 1
          Product      = 'IGEL OS 11'
          Version      = '11.3.100.1'
          FirmwareType = 'LX'
        }
        @{
          Id           = 2
          Product      = 'IGEL OS 11'
          Version      = '11.3.110.1'
          FirmwareType = 'LX'
        }
      )
      Options  = @{
        #ExcludedPaths             = 'Id'
      }
    }
    @{
      Function = 'New-UMSProfileAssignment'
      Params1  = @{
        Id           = 538 # NW_WLAN
        ReceiverId   = 504 # BR_HR
        ReceiverType = 'tcdirectory'
      }
      Params2  = @{
        Id           = 538 # NW_WLAN
        ReceiverId   = 577 # BR-MKT-003
        ReceiverType = 'tc'
      }
      Expected = @(
        @{
          Id           = 538
          Message      = '1 asssignments successfully assigned to device directory <{1}>.'
          ReceiverId   = 504
          ReceiverType = 'tcdirectory'
        }
        @{
          Id           = 538
          Message      = '1 asssignments successfully assigned to device <{1}>.'
          ReceiverId   = 577
          ReceiverType = 'tc'
        }
      )
      Options  = @{
        ExcludedPaths = ''
      }
    }
    @{
      Function = 'Remove-UMSDevice'
      Params1  = @{
        Id = 572 # L-DIS-011
      }
      Params2  = @{
        Id = 522 # L-DIS-012
      }
      Expected = @(
        @{
          Id      = 572
          Message = 'Offline deletion successful.'
        }
        @{
          Id      = 522
          Message = 'Offline deletion successful.'
        }
      )
      Options  = @{
        ExcludedPaths = ''
      }
    }
    @{
      Function = 'Remove-UMSDeviceDirectory'
      Params1  = @{
        Id = 520 # L_Distribution
      }
      Expected = @(
        @{
          Id      = 520
          Message = 'Deletion successful.'
        }
      )
      Options  = @{
        ExcludedPaths = ''
      }
    }
    @{
      Function = 'Remove-UMSProfile'
      Params1  = @{
        Id = 542 # SYS_TZ_CET
      }
      Expected = @{
        Message = 'Deleted profile.'
        Id      = 542
      }
      Options  = @{
        ExcludedPaths = ''
      }
    }
    @{
      Function = 'Remove-UMSProfileDirectory'
      Params1  = @{
        Id = 541 # System
      }
      Expected = @{
        Message = 'Deletion successful.'
        Id      = 541
      }
      Options  = @{
        ExcludedPaths = ''
      }
    }
    @{
      Function = 'Remove-UMSProfileAssignment'
      Params1  = @{
        Id           = 538 # NW_WLAN
        ReceiverId   = 505 # BR-HR-01
        ReceiverType = 'tc'
      }
      Params2  = @{
        Id           = 540 # SEC_PW_Root
        ReceiverId   = 502 # PSIGEL
        ReceiverType = 'tcdirectory'
      }
      Expected = @(
        @{
          Message      = 'deleted profile assignment.'
          Id           = 538
          ReceiverId   = 505
          ReceiverType = 'tc'
        }
        @{
          Message      = 'deleted profile assignment.'
          Id           = 540
          ReceiverId   = 502
          ReceiverType = 'tcdirectory'
        }
      )
      Options  = @{
        ExcludedPaths = ''
      }
    }
    @{
      Function = 'Move-UMSDeviceDirectory'
      Params1  = @{
        Id     = 593 # QA
        DestId = 511 # Augsburg
      }
      Expected = @(
        @{
          Id      = 593
          Message = 'successful.'
        }
      )
      Options  = @{
        ExcludedPaths = ''
      }
    }
  )

  <#
  Tests            = [ordered]@{
    'Move-UMSDevice -Id 518 -DestId 514'                                                                     = @(
      @{
        Id      = 518
        Message = 'successful.'
      }
    )
    '617, 621 | Move-UMSDevice -DestId 613'                                                                  = @(
      @{
        Id      = 617 #dynamisch
        Message = 'successful.'
      }
      @{
        Id      = 621 # dynamisch
        Message = 'successful.'
      }
    )
    '517 | Move-UMSDeviceDirectory -DestId 503'                                                              = @(
      @{
        Id      = 517
        Message = 'successful.'
      }
    )
    'Move-UMSProfile -Id 535 -DestId 534'                                                                    = @(
      @{
        Id      = 535
        Message = 'successful'
      }
    )
    'Move-UMSProfileDirectory -Id 534 -DestId 527'                                                           = @(
      @{
        Id      = 535
        Message = 'successful'
      }
    )
    'Update-UMSDeviceDirectory -Id 517 -Name "Distribution"'                                                 = @(
      @{
        Message = 'Updated directory successfully.'
        Id      = 517
      }
    )
    ' Update-UMSDevice -Id 578 -Name "BR-DIS-010"'                                                           = @(
      @{
        Message = 'Update successful.'
        Id      = 578
      }
    )
    'Update-UMSDevice -Id 518 -Name "A-DEV-009"'                                                             = @(
      @{
        Message = 'Update successful.'
        Id      = 518
      }
    )
    #Origin rename to "PRO_NW_LNG_DE"
    'Update-UMSProfile -Id 535 -Name "PRO_LNG_DE"'                                                           = @(
      @{
        Message = 'Update successful.'
        Id      = 535
      }
    )
    'Update-UMSProfileDirectory -Id 534 -Name "User Interface"'                                              = @(
      @{
        Message = 'Updated directory successfully.'
        Id      = 534
      }
    )
    'Get-UMSDevice | Sort-Object -Property Id | Select-Object -First 2'                                      = @(
      @{
        Id         = 505
        ObjectType = 'tc'
        UnitId     = '0A0000000001'
        Mac        = '0A0000000001'
        Name       = 'BR-HR-001'
        ParentId   = 504
        FirmwareId = 1
        LastIp     = ''
        MovedToBin = 'False'
      }
      @{
        Id         = 507
        ObjectType = 'tc'
        UnitId     = '0A0000000002'
        Mac        = '0A0000000002'
        Name       = 'BR-HR-002'
        ParentId   = 504
        FirmwareId = 1
        LastIp     = ''
        MovedToBin = 'False'
      }
    )
    '518 | Get-UMSDevice -Filter details'                                                                    = @(
      @{
        Id                        = 518
        ObjectType                = 'tc'
        UnitId                    = '0A0000000009'
        Mac                       = '0A0000000009'
        Name                      = 'A-DEV-009'
        ParentId                  = 514
        FirmwareId                = 1
        LastIp                    = ''
        MovedToBin                = 'False'
        NetworkName               = ''
        Site                      = ''
        Comment                   = ''
        Department                = ''
        CostCenter                = ''
        AssetID                   = ''
        InServiceDate             = ''
        SerialNumber              = ''
        ProductId                 = ''
        CpuSpeed                  = 0
        CpuType                   = ''
        DeviceType                = ''
        DeviceSerialNumber        = ''
        OsType                    = ''
        FlashSize                 = 0
        MemorySize                = 0
        NetworkSpeed              = 0
        GraphicsChipset0          = ''
        GraphicsChipset1          = ''
        MonitorVendor1            = ''
        MonitorModel1             = ''
        MonitorSerialnumber1      = ''
        MonitorSize1              = 0
        MonitorNativeResolution1  = ''
        Monitor1YearOfManufacture = 0
        Monitor1WeekOfManufacture = 0
        MonitorVendor2            = ''
        MonitorModel2             = ''
        MonitorSerialnumber2      = ''
        MonitorSize2              = 0
        MonitorNativeResolution2  = ''
        Monitor2YearOfManufacture = 0
        Monitor2WeekOfManufacture = 0
        BiosVendor                = ''
        BiosVersion               = ''
        TotalUsagetime            = -1
        TotalUptime               = -1
        BatteryLevel              = -1
        LastBootTime              = ''
        BiosDate                  = ''
      }
    )
    'Get-UMSDevice -Id 578 -Filter online'                                                                   = @(
      @{
        Id         = 578
        ObjectType = tc
        UnitId     = '0A0000000010'
        Mac        = '0A0000000010'
        Name       = 'BR-DIS-010'
        ParentId   = 517
        FirmwareId = 2
        LastIp     = ''
        MovedToBin = 'False'
        Online     = 'False'
      }
    )
    '(Get-UMSDevice).Count'                                                                                  = @(
      10
    )
    'Get-UMSDeviceDirectory | Sort-Object -Property Id -Descending | Select-Object -First 2'                 = @(
      @{
        Id         = 613
        Name       = 'QandA'
        ParentId   = 511
        MovedToBin = 'False'
        ObjectType = 'tcdirectory'
      }
      @{
        Id         = 517
        Name       = 'Distribution'
        ParentId   = 503
        MovedToBin = 'False'
        ObjectType = 'tcdirectory'
      }
    )
    '517 | Get-UMSDeviceDirectory'                                                                           = @(
      @{
        Id         = 517
        Name       = 'Distribution'
        ParentId   = 503
        MovedToBin = 'False'
        ObjectType = 'tcdirectory'
      }
    )
    '(Get-UMSDeviceDirectory -Id 503 -Filter children).DirectoryChildren'                                    = @(
      @{
        ObjectType = 'tcdirectory'
        Id         = 504
      }
      @{
        ObjectType = 'tcdirectory'
        Id         = 508
      }
      @{
        ObjectType = 'tcdirectory'
        Id         = 517
      }
    )
    'Get-UMSProfile | Sort-Object -Property Id | Select-Object -First 2'                                     = @(
      @{
        FirmwareId        = 1
        IsMasterProfile   = 'False'
        OverridesSessions = 'False'
        Id                = 529
        Name              = 'PRO_RDP_Session01'
        ParentId          = 528
        MovedToBin        = 'False'
        ObjectType        = 'profile'
      }
      @{
        FirmwareId        = 1
        IsMasterProfile   = 'False'
        OverridesSessions = 'False'
        Id                = 532
        Name              = 'PRO_Terminal_LocalTerminal'
        ParentId          = 531
        MovedToBin        = 'False'
        ObjectType        = 'profile'
      }
    )
    '535 | Get-UMSProfile'                                                                                   = @(
      @{
        FirmwareId        = 2
        IsMasterProfile   = 'False'
        OverridesSessions = 'False'
        Id                = 535
        Name              = 'PRO_LNG_DE'
        ParentId          = 534
        MovedToBin        = 'False'
        ObjectType        = 'profile'
      }
    )
    '(Get-UMSProfile).Count'                                                                                 = @(
      6
    )
    'Get-UMSProfileDirectory | Sort-Object -Property Id -Descending | Select-Object -First 2'                = @(
      @{
        Id         = 623
        Name       = 'Devices'
        ParentId   = '-2'
        MovedToBin = 'False'
        ObjectType = 'profiledirectory'
      }
      @{
        Id         = 539
        Name       = 'Security'
        ParentId   = 527
        MovedToBin = 'False'
        ObjectType = 'profiledirectory'
      }
    )
    '(Get-UMSProfileDirectory -Id 533 -Filter children).DirectoryChildren'                                   = @(
      @{
        ObjectType = 'profile'
        id         = 537
      }
      @{
        ObjectType = 'profile'
        id         = 538
      }
    )
    'Get-UMSProfileAssignment -Id 538'                                                                       = @(
      @{
        Id                 = 538
        Get                = 'profile'
        ReceiverId         = 577
        ReceiverType       = 'tc'
        AssignmentPosition = 0
      }
    )
    '538 | Get-UMSProfileAssignment -Directory'                                                              = @(
      @{
        Id                 = 538
        Type               = 'profile'
        ReceiverId         = 504
        ReceiverType       = 'tcdirectory'
        AssignmentPosition = 0
      }
      @{
        Id                 = 538
        Type               = 'profile'
        ReceiverId         = 517
        ReceiverType       = 'tcdirectory'
        AssignmentPosition = 1
      }
    )
    '(Get-UMSDeviceAssignment -Id 577).Count'                                                                = @(
      4
    )
    '577 | Get-UMSDeviceAssignment'                                                                          = @(
      @{
        Id                 = 577
        ReceiverId         = 577
        ReceiverType       = 'tc'
        AssigneeId         = 538
        AssigneeType       = 'profile'
        AssignmentPosition = 0
      }
      @{
        Id                 = 577
        ReceiverId         = 503
        ReceiverType       = 'tcdirectory'
        AssigneeId         = 537
        AssigneeType       = 'profile'
        AssignmentPosition = 1
      }
      @{
        Id                 = 577
        ReceiverId         = 502
        ReceiverType       = 'tcdirectory'
        AssigneeId         = 529
        AssigneeType       = 'profile'
        AssignmentPosition = 2
      }
      @{
        Id                 = 577
        ReceiverId         = 502
        ReceiverType       = 'tcdirectory'
        AssigneeId         = 535
        AssigneeType       = 'profile'
        AssignmentPosition = 3
      }
    )
    '(Get-UMSDeviceDirectoryAssignment -Id 514).Count'                                                       = @(
      3
    )
    '514 | Get-UMSDeviceDirectoryAssignment'                                                                 = @(
      @{
        Id                 = 514
        ReceiverId         = 514
        ReceiverType       = 'tcdirectory'
        AssigneeId         = 532
        AssigneeType       = 'profile'
        AssignmentPosition = 0
      }
      @{
        Id                 = 514
        ReceiverId         = 502
        ReceiverType       = 'tcdirectory'
        AssigneeId         = 535
        AssigneeType       = 'profile'
        AssignmentPosition = 1
      }
      @{
        Id                 = 514
        ReceiverId         = 502
        ReceiverType       = 'tcdirectory'
        AssigneeId         = 529
        AssigneeType       = 'profile'
        AssignmentPosition = 2
      }
    )
    'Get-UMSDirectoryRecursive -Id 511 -DirectoryColl (Get-UMSDeviceDirectory)'                              = @(
      @{
        Id         = 511
        Name       = 'Augsburg'
        ParentId   = 502
        MovedToBin = 'False'
        ObjectType = 'tcdirectory'
      }
      @{
        Id         = 514
        Name       = 'Development'
        ParentId   = 511
        MovedToBin = 'False'
        ObjectType = 'tcdirectory'
      }
      @{
        Id         = 613
        Name       = 'QandA'
        ParentId   = 511
        MovedToBin = 'False'
        ObjectType = 'tcdirectory'
      }
    )
    'Get-UMSDirectoryRecursive -Id 511 -DirectoryColl (Get-UMSDeviceDirectory) -ElementColl (Get-UMSDevice)' = @(
      @{
        Id         = 512
        ObjectType = 'tc'
        UnitId     = '0A0000000005'
        Mac        = '0A0000000005'
        Name       = 'A-DEV-005'
        ParentId   = 514
        FirmwareId = 1
        LastIp     = ''
        MovedToBin = 'False'
      }
      @{
        Id         = 513
        ObjectType = 'tc'
        UnitId     = '0A0000000006'
        Mac        = '0A0000000006'
        Name       = 'A-DEV-006'
        ParentId   = 514
        FirmwareId = 1
        LastIp     = ''
        MovedToBin = 'False'
      }
      @{
        Id         = 518
        ObjectType = 'tc'
        UnitId     = '0A0000000009'
        Mac        = '0A0000000009'
        Name       = 'A-DEV-009'
        ParentId   = 514
        FirmwareId = 1
        LastIp     = ''
        MovedToBin = 'False'
      }
      @{
        Id         = 617
        ObjectType = 'tc'
        UnitId     = '0A0000000007'
        Mac        = '0A0000000007'
        Name       = 'A-QA-007'
        ParentId   = 613
        FirmwareId = 1
        LastIp     = ''
        MovedToBin = 'False'
      }
      @{
        Id         = 621
        ObjectType = 'tc'
        UnitId     = '0A0000000008'
        Mac        = '0A0000000008'
        Name       = 'A-QA-008'
        ParentId   = 613
        FirmwareId = 1
        LastIp     = ''
        MovedToBin = 'False'
      }
    )
  }
#>
}