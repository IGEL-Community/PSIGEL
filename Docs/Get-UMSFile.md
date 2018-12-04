---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSFile.md
schema: 2.0.0
---

# Get-UMSFile

## SYNOPSIS
Get Files.

## SYNTAX

```
Get-UMSFile [-ServerInstance] <String> [-Database] <String> [-Schema] <String> [[-Credential] <PSCredential>]
 [[-FileID] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Get Files from UMS DB via Invoke-SQLcmd2.

## EXAMPLES

### Example 1
```powershell
$Params = @{
Credential     = Get-Credential
  ServerInstance = 'SQLSERVER\RMDB'
  Database       = 'RMDB'
  Schema         = 'igelums'
}
Get-UMSFile @Params
```

```
FILEID         : 25283
FILEURL        : https://${serverhostname:port}$/ums_filetransfer/Certificate.cer
TCURL          :
CLASSIFICATION : 25
MD5            : 250D3D6EB54DC8DA9019011032837E8G
MD5Date        : 02.05.2018 08:51:28
USERNAME       :
PASSWORD       :
OWNER          : user
PERMISSION     : rwx---
FILE_HIDDEN    : 0
MOVEDTOBIN     :
DIRID          :

FILEID         : 35196
FILEURL        : https://${serverhostname:port}$/ums_filetransfer/99wlan
TCURL          : /etc/NetworkManager/dispatcher.d
CLASSIFICATION : 0
MD5            : 7ED6277D54B8E4EAE913F0BD5E8ECCA7
MD5Date        : 05.06.2018 10:44:56
USERNAME       :
PASSWORD       :
OWNER          : root
PERMISSION     : rwxr-x
FILE_HIDDEN    : 0
MOVEDTOBIN     :  : 0
MOVEDTOBIN     :
DIRID          : 50194
```

Gets all Files

### Example 2
```powershell
653, 654 | Get-UMSFile -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
```

Gets Files with FileID "653" and "654"

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
SQL Database for the UMS-DB (e.g.
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
SQL Schema for the UMS-DB (e.g.
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

### -FileID
ID of File to get

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
