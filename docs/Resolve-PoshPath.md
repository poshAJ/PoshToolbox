---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://gitlab.com/PoshAJ/PoshToolbox/-/blob/main/docs/Resolve-PoshPath.md
schema: 2.0.0
---

# Resolve-PoshPath

## SYNOPSIS

Resolves a path with wildcard support.

## SYNTAX

### Path

```powershell
Resolve-PoshPath [-Path] <String[]> [<CommonParameters>]
```

### LiteralPath

```powershell
Resolve-PoshPath -LiteralPath <String[]> [<CommonParameters>]
```

## DESCRIPTION

The `Resolve-PoshPath` function resolves a drive or provider qualified absolute or relative path that may contain wildcard characters into one or more provider-internal paths.

## EXAMPLES

## PARAMETERS

### -LiteralPath

Specifies the path to be resolved. The value of the LiteralPath parameter is used exactly as typed. No characters are interpreted as wildcard character

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

Specifies the PowerShell path to resolve.

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

### CommonParameters

This function supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String

You can pipe a string that contains a path to this function.

## OUTPUTS

### PoshToolbox.ResolvePoshPathCommand+PoshPathInfo

Returns a PoshPathInfo object for each resolved path.

## NOTES

This function is designed to work with the data exposed by any provider. To list the providers available in your session, type Get-PSProvider. For more information, see [about_Providers](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_providers).

## RELATED LINKS

[https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.pathintrinsics.getresolvedproviderpathfrompspath]()
[https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.pathintrinsics.getunresolvedproviderpathfrompspath]()
