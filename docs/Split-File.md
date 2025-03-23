---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://gitlab.com/PoshAJ/PoshToolbox/-/blob/main/docs/Split-File.md
schema: 2.0.0
---

# Split-File

## SYNOPSIS

Splits large files into several smaller files.

## SYNTAX

### Path

```powershell
Split-File [-Path] <String[]> [-Destination <String>] -Size <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### LiteralPath

```powershell
Split-File -LiteralPath <String[]> [-Destination <String>] -Size <Int32> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The `Split-File` cmdlet separates a file into parts of the specified size.

## EXAMPLES

## PARAMETERS

### -Destination

Specifies the path to the new location. The default is the current directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LiteralPath

Specifies a path to one or more locations. The value of LiteralPath is used exactly as it's typed.

```yaml
Type: String[]
Parameter Sets: LiteralPath
Aliases: PSPath

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path

Specifies a path to one or more locations. Wildcards are accepted.

```yaml
Type: String[]
Parameter Sets: Path
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Size

Specifies the maximum size in bytes of each split file.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
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

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String

You can pipe a string that contains a file path to this cmdlet.

## OUTPUTS

### System.IO.FileInfo

Returns a FileInfo object for each split file.

## NOTES

## RELATED LINKS

[None]()
