---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/New-UMSThinclient.md
schema: 2.0.0
---

# New-UMSThinclient

## SYNOPSIS
Creates a new thinclient from Rest API.

## SYNTAX

```
New-UMSThinclient [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-WebSession] <Object>] [-Mac] <String> [-FirmwareID] <Int32> [[-Name] <String>] [[-ParentID] <Int32>]
 [[-Site] <String>] [[-Department] <String>] [[-CostCenter] <String>] [[-LastIP] <String>]
 [[-Comment] <String>] [[-AssetID] <String>] [[-InserviceDate] <String>] [[-SerialNumber] <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new thinclient from Rest API.

## EXAMPLES

### BEISPIEL 1
```
$Computername = 'UMSSERVER'
$Params = @{
  Computername  = $Computername
  WebSession    = New-UMSAPICookie -Computername $Computername
  Mac           = '012345678910'
  FirmwareID    = 9
  Name          = 'TC012345'
  ParentID      = 772
  Site          = 'Leipzig'
  Department    = 'Marketing'
  CostCenter    = '50100'
  LastIP        = '192.168.0.10'
  Comment       = 'New Thinclient'
  AssetID       = '012345'
  InserviceDate = '01.01.2018'
  SerialNumber  = '12A3B4C56B12345A6BC'
  Confirm       = $true
}
New-UMSThinclient @Params
```
Creates a new thinclient with all possible attributes, after confirmation.

### BEISPIEL 2
```
New-UMSThinclient -Computername 'UMSSERVER' -Mac '012345678910' -FirmwareID 9
```

Creates new thinclient with mac, name and firmwareid (minimal requirements) in the root directory.

## PARAMETERS

### -Computername
Computername of the UMS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TCPPort
TCP Port (Default: 8443)

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

### -Mac
Mac-Address in format '001122AABBCC'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirmwareID
FirmwareID of the Thinclient

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Hostname of the Thinclient

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentID
ID of the parent directory of the thinclient (Default: -1)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Site
Thinclient Attribute Site

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Department
Thinclient Attribute Department

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CostCenter
Thinclient Attribute CostCenter

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastIP
Thinclient Attribute LastIP

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
Thinclient Attribute Comment

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetID
Thinclient Attribute AssetID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InserviceDate
Thinclient Attribute InserviceDate

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SerialNumber
Thinclient Attribute SerialNumber

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
