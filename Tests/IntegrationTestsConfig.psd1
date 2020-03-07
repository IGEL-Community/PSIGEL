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
      Function      = 'Get-UMSStatus'
      ParameterSets = @{
        Default = @{
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
      }
    }
    @{
      Function      = 'New-UMSDeviceDirectory'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Name = 'QA'
          }
          Expected = @{
            Message = 'Directory successfully inserted.'
            Id      = 594
            Name    = 'QA'
          }
          Options  = @{
            #ExcludedPaths = 'Id'
          }
        }
      }
    }
    @{
      Function      = 'New-UMSDevice'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Mac        = '0A0000000007'
            Name       = '007'
            FirmwareId = 1
            ParentId   = -1
          }
          Params2  = @{
            Mac        = '0A0000000008'
            Name       = '008'
            FirmwareId = 1
            ParentId   = -1
          }
          Expected = @(
            @{
              Mac      = '0A0000000007'
              Message  = 'Device successfully inserted.'
              Id       = 595
              Name     = '007'
              ParentId = -1
            }
            @{
              Mac      = '0A0000000008'
              Message  = 'Device successfully inserted.'
              Id       = 596
              Name     = '008'
              ParentId = - 1
            }
          )
          Options  = @{
            #ExcludedPaths = 'Id'
          }
        }
      }
    }
    @{
      Function      = 'New-UMSProfileDirectory'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Name = 'Devices'
          }
          Expected = @{
            Message = 'Directory successfully inserted.'
            Id      = 597
            Name    = 'Devices'
          }
          Options  = @{
            #ExcludedPaths = 'Id'
          }
        }
      }
    }
    @{
      Function      = 'Get-UMSFirmware'
      ParameterSets = @{
        Default = @{
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
      }
    }
    @{
      Function      = 'New-UMSProfileAssignment'
      ParameterSets = @{
        Default = @{
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
      }
    }
    @{
      Function      = 'Remove-UMSDevice'
      ParameterSets = @{
        Default = @{
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
      }
    }
    @{
      Function      = 'Remove-UMSDeviceDirectory'
      ParameterSets = @{
        Default = @{
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
      }
    }
    @{
      Function      = 'Remove-UMSProfile'
      ParameterSets = @{
        Default = @{
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
      }
    }
    @{
      Function      = 'Remove-UMSProfileDirectory'
      ParameterSets = @{
        Default = @{
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
      }
    }
    @{
      Function      = 'Remove-UMSProfileAssignment'
      ParameterSets = @{
        Default = @{
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
      }
    }
    @{
      Function      = 'Move-UMSDevice'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Id     = 518 # L-DEV-009
            DestId = 514 # A_Development
          }
          Params2  = @{
            Id     = 578 # L-DEV-010
            DestId = 514 # A_Development
          }
          Params3  = @{
            Id     = 595 # 007
            DestId = 594 # QA
          }
          Params4  = @{
            Id     = 596 # 008
            DestId = 594 # QA
          }
          Expected = @(
            @{
              Id      = 518
              Message = 'successful.'
            }
            @{
              Id      = 578
              Message = 'successful.'
            }
            @{
              Id      = 595
              Message = 'successful.'
            }
            @{
              Id      = 596
              Message = 'successful.'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Move-UMSDeviceDirectory'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Id     = 594 # QA
            DestId = 511 # Augsburg
          }
          Params2  = @{
            Id     = 517 # L_Development
            DestId = 503 # Bremen
          }
          Expected = @(
            @{
              Id      = 594
              Message = 'successful.'
            }
            @{
              Id      = 517
              Message = 'successful.'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Move-UMSProfileDirectory'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Id     = 534 # Network User Interface
            DestId = 527 # PSIGEL
          }
          Expected = @(
            @{
              Id      = 534
              Message = 'successful.'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Move-UMSProfile'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Id     = 535 # NW_LNG_DE
            DestId = 534 # Interface
          }
          Expected = @(
            @{
              Id      = 535
              Message = 'successful'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Update-UMSDeviceDirectory'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Id   = 517 # L_Develpoment
            Name = 'BR_Development'
          }
          Params2  = @{
            Id   = 594 # QA
            Name = 'A_QA'
          }
          Expected = @(
            @{
              Id      = 517
              Message = 'Updated directory successfully.'
            }
            @{
              Id      = 594
              Message = 'Updated directory successfully.'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Update-UMSDevice'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Id   = 518 # L-DEV-009
            Name = 'A-DEV-009'
          }
          Params2  = @{
            Id   = 578 # L-DEV-010
            Name = 'A-DEV-010'
          }
          Params3  = @{
            Id   = 595 # 007
            Name = 'A-QA-007'
          }
          Params4  = @{
            Id   = 596 # 008
            Name = 'A-QA-008'
          }
          Expected = @(
            @{
              Id      = 518
              Message = 'Update successful.'
            }
            @{
              Id      = 578
              Message = 'Update successful.'
            }
            @{
              Id      = 595
              Message = 'Update successful.'
            }
            @{
              Id      = 596
              Message = 'Update successful.'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Update-UMSProfileDirectory'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Id   = 534 # Network user Interface
            Name = 'User Interface'
          }
          Expected = @(
            @{
              Id      = 534
              Message = 'Updated directory successfully.'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Update-UMSProfile'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Id   = 535 # NW_LNG_DE
            Name = 'UI_LNG_DE' #
          }
          Expected = @(
            @{
              Id      = 535
              Message = 'Update successful.'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Get-UMSDevice'
      ParameterSets = @{
        Default = @{
          Params1  = @{
          }
          Expected = @(
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
              Id         = 576
              ObjectType = 'tc'
              UnitId     = '0A0000000004'
              Mac        = '0A0000000004'
              Name       = 'BR-MKT-004'
              ParentId   = 508
              FirmwareId = 2
              LastIp     = ''
              MovedToBin = 'False'
            }
            @{
              Id         = 577
              ObjectType = 'tc'
              UnitId     = '0A0000000003'
              Mac        = '0A0000000003'
              Name       = 'BR-MKT-003'
              ParentId   = 508
              FirmwareId = 2
              LastIp     = ''
              MovedToBin = 'False'
            }
            @{
              Id         = 578
              ObjectType = 'tc'
              UnitId     = '0A0000000010'
              Mac        = '0A0000000010'
              Name       = 'A-DEV-010'
              ParentId   = 514
              FirmwareId = 2
              LastIp     = ''
              MovedToBin = 'False'
            }
            @{
              Id         = 595
              ObjectType = 'tc'
              UnitId     = '0A0000000007'
              Mac        = '0A0000000007'
              Name       = 'A-QA-007'
              ParentId   = 594
              FirmwareId = 1
              LastIp     = ''
              MovedToBin = 'False'
            }
            @{
              Id         = 596
              ObjectType = 'tc'
              UnitId     = '0A0000000008'
              Mac        = '0A0000000008'
              Name       = 'A-QA-008'
              ParentId   = 594
              FirmwareId = 1
              LastIp     = ''
              MovedToBin = 'False'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
        Details = @{
          Params1  = @{
            Id     = 518 # A-DEV-009
            Filter = 'details'
          }
          Expected = @(
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
          Options  = @{
            ExcludedPaths = ''
          }
        }
        Online  = @{
          Params1  = @{
            Id     = 578 # A-DEV-010
            Filter = 'online'
          }
          Expected = @(
            @{
              Id         = 578
              ObjectType = 'tc'
              UnitId     = '0A0000000010'
              Mac        = '0A0000000010'
              Name       = 'A-DEV-010'
              ParentId   = 514
              FirmwareId = 2
              LastIp     = ''
              MovedToBin = 'False'
              Online     = 'False'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Get-UMSDeviceDirectory'
      ParameterSets = @{
        Default  = @{
          Params1  = @{
          }
          Expected = @(
            @{
              Id         = 514
              Name       = 'A_Development'
              ParentId   = 511
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
            @{
              Id         = 594
              Name       = 'A_QA'
              ParentId   = 511
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
            @{
              Id         = 516
              Name       = 'Leipzig'
              ParentId   = 502
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
            @{
              Id         = 517
              Name       = 'BR_Development'
              ParentId   = 503
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
            @{
              Id         = 502
              Name       = 'PSIGEL'
              ParentId   = -1
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
            @{
              Id         = 503
              Name       = 'Bremen'
              ParentId   = 502
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
            @{
              Id         = 504
              Name       = 'BR_HR'
              ParentId   = 503
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
            @{
              Id         = 508
              Name       = 'BR_Marketing'
              ParentId   = 503
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
            @{
              Id         = 511
              Name       = 'Augsburg'
              ParentId   = 502
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
        Children = @{
          Params1  = @{
            Id     = 514 # A-DEV-009
            Filter = 'children'
          }
          Expected = @(
            @{
              Id                = 514
              Name              = 'A_Development'
              ParentId          = 511
              MovedToBin        = 'False'
              ObjectType        = 'tcdirectory'
              DirectoryChildren = {
                @{
                  ObjectType = 'tc'
                  Id         = 512
                }
                @{
                  ObjectType = 'tc'
                  Id         = 578
                }
                @{
                  ObjectType = 'tc'
                  Id         = 513
                }
                @{
                  ObjectType = 'tc'
                  Id         = 518
                }
              }
            }
          )
          Options  = @{
            ExcludedPaths = 'DirectoryChildren'
          }
        }
      }
    }
    @{
      Function      = 'Get-UMSProfile'
      ParameterSets = @{
        Default = @{
          Params1  = @{
          }
          Expected = @(
            @{
              FirmwareId        = 1
              IsMasterProfile   = 'False'
              OverridesSessions = 'False'
              Id                = 529
              Name              = 'SES_RDP_Session01'
              ParentId          = 528
              MovedToBin        = 'False'
              ObjectType        = 'profile'
            }
            @{
              FirmwareId        = 1
              IsMasterProfile   = 'False'
              OverridesSessions = 'False'
              Id                = 532
              Name              = 'ACC_Terminal_LocalTerminal'
              ParentId          = 531
              MovedToBin        = 'False'
              ObjectType        = 'profile'
            }
            @{
              FirmwareId        = 2
              IsMasterProfile   = 'False'
              OverridesSessions = 'False'
              Id                = 535
              Name              = 'UI_LNG_DE'
              ParentId          = 534
              MovedToBin        = 'False'
              ObjectType        = 'profile'
            }
            @{
              FirmwareId        = 2
              IsMasterProfile   = 'False'
              OverridesSessions = 'False'
              Id                = 537
              Name              = 'NW_LAN'
              ParentId          = 533
              MovedToBin        = 'False'
              ObjectType        = 'profile'
            }
            @{
              FirmwareId        = 2
              IsMasterProfile   = 'False'
              OverridesSessions = 'False'
              Id                = 538
              Name              = 'NW_WLAN'
              ParentId          = 533
              MovedToBin        = 'False'
              ObjectType        = 'profile'
            }
            @{
              FirmwareId        = 1
              IsMasterProfile   = 'False'
              OverridesSessions = 'False'
              Id                = 540
              Name              = 'SEC_PW_Root'
              ParentId          = 539
              MovedToBin        = 'False'
              ObjectType        = 'profile'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Get-UMSProfileDirectory'
      ParameterSets = @{
        Default  = @{
          Params1  = @{
          }
          Expected = @(
            @{
              Id         = 528
              Name       = 'Sessions'
              ParentId   = 527
              MovedToBin = 'False'
              ObjectType = 'profiledirectory'
            }
            @{
              Id         = 531
              Name       = 'Accessories'
              ParentId   = 527
              MovedToBin = 'False'
              ObjectType = 'profiledirectory'
            }
            @{
              Id         = 533
              Name       = 'Network'
              ParentId   = 527
              MovedToBin = 'False'
              ObjectType = 'profiledirectory'
            }
            @{
              Id         = 597
              Name       = 'Devices'
              ParentId   = -2
              MovedToBin = 'False'
              ObjectType = 'profiledirectory'
            }
            @{
              Id         = 534
              Name       = 'User Interface'
              ParentId   = 527
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
            @{
              Id         = 527
              Name       = 'PSIGEL'
              ParentId   = -2
              MovedToBin = 'False'
              ObjectType = 'profiledirectory'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
        Children = @{
          Params1  = @{
            Id     = 533 # Network
            Filter = 'children'
          }
          Expected = @(
            @{
              Id                = 533
              Name              = 'Network'
              ParentId          = 527
              MovedToBin        = 'False'
              ObjectType        = 'profiledirectory'
              DirectoryChildren = {
                @{
                  ObjectType = 'profile'
                  Id         = 537
                }
                @{
                  ObjectType = 'profile'
                  Id         = 538
                }
              }
            }
          )
          Options  = @{
            ExcludedPaths = 'DirectoryChildren'
          }
        }
      }
    }
    @{
      Function      = 'Get-UMSProfileAssignment'
      ParameterSets = @{
        Default   = @{
          Params1  = @{
            Id = 538 # NW_LAN
          }
          Expected = @(
            @{
              Id                 = 538
              Type               = 'profile'
              ReceiverId         = 577
              ReceiverType       = 'tc'
              AssignmentPosition = 0
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
        Directory = @{
          Params1  = @{
            Id        = 538 # NW_LAN
            Directory = $true
          }
          Expected = @(
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
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Get-UMSDeviceAssignment'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Id = 577 # BR-MKT-003
          }
          Expected = @(
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
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Get-UMSDeviceDirectoryAssignment'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            Id = 504 # BR_HR
          }
          Expected = @(
            @{
              Id                 = 504
              ReceiverId         = 504
              ReceiverType       = 'tcdirectory'
              AssigneeId         = 538
              AssigneeType       = 'profile'
              AssignmentPosition = 0
            }
            @{
              Id                 = 504
              ReceiverId         = 502
              ReceiverType       = 'tcdirectory'
              AssigneeId         = 535
              AssigneeType       = 'profile'
              AssignmentPosition = 1
            }
            @{
              Id                 = 504
              ReceiverId         = 502
              ReceiverType       = 'tcdirectory'
              AssigneeId         = 529
              AssigneeType       = 'profile'
              AssignmentPosition = 2
            }
            @{
              Id                 = 504
              ReceiverId         = 503
              ReceiverType       = 'tcdirectory'
              AssigneeId         = 537
              AssigneeType       = 'profile'
              AssignmentPosition = 3
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
    @{
      Function      = 'Get-UMSDirectoryRecursive'
      ParameterSets = @{
        Default = @{
          Params1  = @{
            #DirectoryColl = 'Get-UMSDeviceDirectory'
            Id = 511 # Augsburg
          }
          Expected = @(
            @{
              Id         = 511
              Name       = 'Augsburg'
              ParentId   = 502
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
            @{
              Id         = 514
              Name       = 'A_Development'
              ParentId   = 511
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
            @{
              Id         = 594
              Name       = 'A_QA'
              ParentId   = 511
              MovedToBin = 'False'
              ObjectType = 'tcdirectory'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
        Element = @{
          Params1  = @{
            #DirectoryColl = 'Get-UMSDeviceDirectory'
            #ElementColl   = 'Get-UMSDevice'
            Id = 511 # Augsburg
          }
          Expected = @(
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
              Id         = 578
              ObjectType = 'tc'
              UnitId     = '0A0000000010'
              Mac        = '0A0000000010'
              Name       = 'A-DEV-010'
              ParentId   = 514
              FirmwareId = 2
              LastIp     = ''
              MovedToBin = 'False'
            }
            @{
              Id         = 595
              ObjectType = 'tc'
              UnitId     = '0A0000000007'
              Mac        = '0A0000000007'
              Name       = 'A-QA-007'
              ParentId   = 594
              FirmwareId = 1
              LastIp     = ''
              MovedToBin = 'False'
            }
            @{
              Id         = 596
              ObjectType = 'tc'
              UnitId     = '0A0000000008'
              Mac        = '0A0000000008'
              Name       = 'A-QA-008'
              ParentId   = 594
              FirmwareId = 1
              LastIp     = ''
              MovedToBin = 'False'
            }
          )
          Options  = @{
            ExcludedPaths = ''
          }
        }
      }
    }
  )
}
