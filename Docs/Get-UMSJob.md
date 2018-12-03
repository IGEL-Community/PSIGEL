---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSJob.md
schema: 2.0.0
---

# Get-UMSJob

## SYNOPSIS
Get Jobs.

## SYNTAX

```
Get-UMSJob [-ServerInstance] <String> [-Database] <String> [-Schema] <String> [[-Credential] <PSCredential>]
 [[-JobID] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Get Jobs from UMS DB via Invoke-SQLcmd2.

## EXAMPLES

### Example 1
```powershell
$Params = @{
  Credential     = Get-Credential
  ServerInstance = 'UMSSERVER\RMDB'
  Database       = 'RMDB'
  Schema         = 'igelums'
}
Get-UMSJob @Params
```

```
ID          : 85207
NAME        : update
COMMAND     : FIRMWARE_UPDATE
STARTDATE   : 09.11.2018 16:38:00
EXPIRED     : 0
TRUSTEEUSER :
MOVEDTOBIN  : 09.11.2018 13:48:53
DIRID       : 85201

ID          : 85211
NAME        : update_on_boot
COMMAND     : UPDATE_NEXT_REBOOT
STARTDATE   : 09.11.2018 16:43:00
EXPIRED     : 0
TRUSTEEUSER :
MOVEDTOBIN  : 09.11.2018 13:48:53
DIRID       : 85201
```

Gets all Jobs

## PARAMETERS

### -Credential
Specifies A PSCredential for SQL Server Authentication connection to an instance of the Database Engine.
If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the
Windows account running the PowerShell session.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Database
SQL Database for the UMS-DB (e.g.
'RMDB')

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

### -JobID
ID of Job to get

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Schema
SQL Schema for the UMS-DB (e.g.
'igelums')

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
SQL ServerInstance for the UMS-DB (e.g.
'SQLSERVER\RMDB')

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
