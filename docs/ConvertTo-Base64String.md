---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://github.com/PoshAJ/PoshToolbox/blob/main/docs/ConvertTo-Base64String.md
schema: 2.0.0
---

# ConvertTo-Base64String

## SYNOPSIS
Converts a file to a Base-64 string.

## SYNTAX

### Path (Default)
```
ConvertTo-Base64String [-Path] <String[]> [-AsString] [-WhatIf] [-Confirm] [-Destination <String>]
 [<CommonParameters>]
```

### LiteralPath
```
ConvertTo-Base64String -LiteralPath <String[]> [-AsString] [-WhatIf] [-Confirm] [-Destination <String>]
 [<CommonParameters>]
```

### InputObject
```
ConvertTo-Base64String -InputObject <Byte[]> [-AsString] [-WhatIf] [-Confirm] [-Destination <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The ConvertTo-Base64String cmdlet returns a Base-64 string that represents the file you submit. You can then use the ConvertFrom-Base64String cmdlet to recreate files from the Base-64 strings.

## EXAMPLES

## PARAMETERS

### -AsString
Outputs the object as a string.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -InputObject
Specifies the byte value to convert.

```yaml
Type: Byte[]
Parameter Sets: InputObject
Aliases:

Required: True
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String
You can pipe a string that contains a file path to this cmdlet.

## OUTPUTS

### PSObject, String
This cmdlet generates a string value, if you specify the AsString parameter. Otherwise, this cmdlet returns a result object for each specified file.

## NOTES

## RELATED LINKS

[None]()
