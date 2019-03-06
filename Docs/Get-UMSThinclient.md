---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSThinclient.md
schema: 2.0.0
---

# Get-UMSThinclient

## SYNOPSIS
Get Thinclients.

## SYNTAX

```
Get-UMSThinclient [[-Computername] <String>] [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-WebSession] <Object>] [[-Details] <String>] [[-TCID] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets Thinclient from UMS via API.

## EXAMPLES

### Example 1
```powershell
$Computername = 'UMSSERVER'
$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
  Details      = 'full'
}
Get-UMSThinclient @Params
```
```
unitID                    : 00E0C5163C78
mac                       : 00E0C5163C78
firmwareID                : 8
networkName               : TC012345
site                      :
department                :
lastIP                    : 10.20.4.102
comment                   :
assetID                   :
inserviceDate             :
serialNumber              :
productId                 : UD3-LX 50ac
umsStructuralTag          :
cpuSpeed                  : 1200
cpuType                   : AMD GX-412HC SOC with Radeon(TM) R3E Graphics
deviceType                : IGEL M340C
deviceSerialNumber        : 14D3E5C02B17171B64M
osType                    : IGEL Linux V5 (Kernel Version 4.4.83)
flashSize                 : 2048
memorySize                : 1717
graphicsChipset0          : ATI MULLINS
graphicsChipset1          :
monitorVendor1            : Samsung Electric Company
monitorModel1             : S22E450
monitorSerialnumber1      : H4LJ201900
monitorSize1              : 21,9
monitorNativeResolution1  : 1680 x 1050
monitor1YearOfManufacture : 2017
monitor1WeekOfManufacture : 7
monitorVendor2            :
monitorModel2             :
monitorSerialnumber2      :
monitorSize2              : 0,0
monitorNativeResolution2  :
monitor2YearOfManufacture :
monitor2WeekOfManufacture :
biosVendor                : Insyde Corp.
biosVersion               : M340C V:3.4.13-02032016
biosDate                  : 02/03/2016
totalUsagetime            : 2105515000
totalUptime               : 36000
lastBoottime              : 2018-11-12 08:01
batteryLevel              : -1
id                        : 2515
name                      : TC012345
parentID                  : 203
movedToBin                : False
objectType                : tc
links                     : {}
```
Gets detailed information on all online thin clients.

### Example 2
```powershell
Get-UMSThinclient -Computername 'UMSSERVER' -TCID 2433
```
```
unitID     : 00E0C513CB46
mac        : 00E0C513CB46
firmwareID : 8
lastIP     : 10.0.7.110
id         : 2433
name       : TC012345
parentID   : 76023
movedToBin : False
objectType : tc
links      : {}
```

Gets short information on thin clients with TCID 2433.

### Example 3
```powershell
2433 | Get-UMSThinclient -Computername 'UMSSERVER' -Details 'shadow'
```
```
unitID       : 00E0C513BA36
mac          : 00E0C513BA36
firmwareID   : 8
lastIP       : 10.0.7.110
shadowSecret : @{certificate=-----BEGIN CERTIFICATE-----
               MIHE1jCCAr6gAwIBAgIESmwpyDANBgkqhkiG9w0BAQ0FADAtMQswCQYDVQQGEwJE
               RTEPMA0GA1UEBxMGQnJlbWVuMQ0wCwYDVQQKEwRJR0VMMB4XDTEzMTIzMTIzMDAw
               MVoXDTM2MTIzMTIzMDAwMVowLTELMAkGA1UEBhMCREUxDzANBgNVBAcTBkJyZW1l
...
               2bx/BO8UfJgb1gHXYSFdgdTBYn0CdSmV/rMmnEHg72WAMKJI64QRYLqQYAE8KrW1
               M5WiENfrUmeYTCbK+du52cr9h+F3FZB3LfyqDWAGtL2CTavYf/pd/ro4yHzjK4fW
               lUpb7tRvPdLf+7USDB4qvYPxwmMwKDsgzYdY+GjOeaRjHxlkWJ0fOeJI
               -----END CERTIFICATE-----
               ; password=731fe746-08c2-42d3-a16e-de5be940bd42}
id           : 2433
name         : TC012345
parentID     : 76023
movedToBin   : False
objectType   : tc
links        : {}
```
Gets shadow-information on Thinclient with TCID 2433

## PARAMETERS

### -Computername
Computername of the UMS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TCPPort
TCP Port API (Default: 8443)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 8443
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
API Version to use (Default: 3)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebSession
Websession Cookie

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Details
Detailed of information on all thin clients ('short','full','inventory','online'; Default:'short')

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Short
Accept pipeline input: False
Accept wildcard characters: False
```

### -TCID
ID of the Thinclient

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
