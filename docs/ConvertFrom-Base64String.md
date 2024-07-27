---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://gitlab.com/PoshAJ/PoshToolbox/-/blob/main/docs/ConvertFrom-Base64String.md
schema: 2.0.0
---

# ConvertFrom-Base64String

## SYNOPSIS

Converts a Base-64 string to an object.

## SYNTAX

```powershell
ConvertFrom-Base64String -InputObject <String[]> [<CommonParameters>]
```

## DESCRIPTION

The `ConvertFrom-Base64String` function returns an object that represents a Base-64 string. You can use the `ConvertTo-Base64String` function to create Base-64 strings from objects.

## EXAMPLES

### Restore a File in Base-64

```powershell
Get-Content -Path "Archive.txt" -Raw | ConvertFrom-Base64String | Set-Content -Path "Archive.zip" -Encoding Byte
```

### Restore an Object in Base-64

```powershell
$Object = ConvertTo-Base64String -InputObject $Base64String
```

## PARAMETERS

### -InputObject

Specifies the string value to convert.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This function supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String

You can pipe a Base-64 string to this function.

## OUTPUTS

### PSObject

This function returns an object representing the input Base-64 string converted to an object.

## NOTES

The `ConvertTo-Base64String` function is implemented using [System.Management.Automation.PSSerializer](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.psserializer).

## RELATED LINKS

[None]()
