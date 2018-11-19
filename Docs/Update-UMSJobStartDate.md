---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version:
schema: 2.0.0
---

# Update-UMSJobStartDate

## SYNOPSIS
Update Job Startdate in UMS-DB

## SYNTAX

```
Update-UMSJobStartDate [-ServerInstance] <String> [-Database] <String> [-Schema] <String>
 [[-Credential] <PSCredential>] [-JobIDColl] <Int32[]> [-Startdate] <DateTime> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Update Job Startdate in UMS-DB

## EXAMPLES

### BEISPIEL 1
```
$Params = @{
```

ServerInstance = 'SQLSERVER\RMDB'
  Database       = 'RMDB'
  Schema         = 'igelums'
  Credential     = (Get-Credential)
  JobIDColl      = 18701
  Startdate      = '2018-01-10 00:06:41'
}
Update-UMSJobStartDate @Params
Update Job Startdate on Job with ID "18701"

### BEISPIEL 2
```
18701,18706 | Update-UMSJobStartDate -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -Startdate '2018-01-10 14:47:00'
```

Update Job Startdate on Jobs with ID "18701" and "18706"

## PARAMETERS

### -ServerInstance
SQL ServerInstance for the UMS-DB (e.g.
'SQLSERVER\RMDB')

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

### -Database
SQL Database  for the UMS-DB (e.g.
'RMDB')

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

### -Schema
SQL Schema  for the UMS-DB (e.g.
'igelums')

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specifies A PSCredential for SQL Server Authentication connection to an instance of the Database Engine.
If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the
Windows account running the PowerShell session.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobIDColl
Array of Job IDs

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Startdate
Startdate to set in Format 'yyyy-MM-dd 00:00:00'

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
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
