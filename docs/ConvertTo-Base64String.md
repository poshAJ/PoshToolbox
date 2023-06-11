---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://github.com/PoshAJ/PoshToolbox/blob/main/docs/ConvertTo-Base64String.md
schema: 2.0.0
---

# ConvertTo-Base64String

## SYNOPSIS
Converts an object to a Base-64 string.

## SYNTAX

```
ConvertTo-Base64String -InputObject <Object> [-Depth <Int32>] [<CommonParameters>]
```

## DESCRIPTION
The ConvertTo-Base64String cmdlet returns a Base-64 string that represents an object. You can then use the ConvertFrom-Base64String cmdlet to recreate objects from the Base-64 strings.

## EXAMPLES

### Represent a File in Base-64
```powershell
Get-Content -Path "Archive.zip" -Encoding Byte -Raw | ConvertTo-Base64String | Set-Content -Path "Archive.txt"
```

### Represent an Object in Base-64
```powershell
$Base64String = ConvertTo-Base64String -InputObject $Object
```

## PARAMETERS

### -Depth
Specifies how many levels of contained objects are included in the Base-64 representation.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Specifies the byte value or object to convert.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### PSObject
You can pipe any object to this cmdlet.

## OUTPUTS

### String
This cmdlet returns a string representing the input object converted to a Base-64 string.

## NOTES
The ConvertTo-Base64String cmdlet is implemented using [System.Management.Automation.PSSerializer](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.psserializer).

## RELATED LINKS

[None]()
