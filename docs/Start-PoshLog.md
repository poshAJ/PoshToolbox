---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://github.com/PoshAJ/PoshToolbox/blob/main/docs/Start-PoshLog.md
schema: 2.0.0
---

# Start-PoshLog

## SYNOPSIS

Creates a log for the PowerShell session.

## SYNTAX

### Path (Default)

```
Start-PoshLog [[-Path] <String[]>] [-AsUtc] [-PassThru] [<CommonParameters>]
```

### PathNoClobber

```
Start-PoshLog [[-Path] <String[]>] [-NoClobber] [-AsUtc] [-PassThru] [<CommonParameters>]
```

### PathAppend

```
Start-PoshLog [[-Path] <String[]>] [-Append] [-AsUtc] [-PassThru] [<CommonParameters>]
```

### LiteralPathNoClobber

```
Start-PoshLog -LiteralPath <String[]> [-NoClobber] [-AsUtc] [-PassThru] [<CommonParameters>]
```

### LiteralPathAppend

```
Start-PoshLog -LiteralPath <String[]> [-Append] [-AsUtc] [-PassThru] [<CommonParameters>]
```

### LiteralPath

```
Start-PoshLog -LiteralPath <String[]> [-AsUtc] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

The `Start-PoshLog` cmdlet creates a record of all or part of a PowerShell session to a text file. The log includes all output from the `Write-PoshLog`, `Write-Information`, `Write-Warning`, and `Write-Error` cmdlets.

Files that are created by the `Start-PoshLog` cmdlet include random characters in names to prevent potential overwrites or duplication when two or more transcripts are started simultaneously.

## EXAMPLES

## PARAMETERS

### -Append

Adds the output to the end of an existing log.

```yaml
Type: SwitchParameter
Parameter Sets: PathAppend, LiteralPathAppend
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsUtc

Converts date values to the equivalent time in UTC.

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

### -LiteralPath

Specifies a path to the log file. The value of LiteralPath is used exactly as it's typed.

```yaml
Type: String[]
Parameter Sets: LiteralPathNoClobber, LiteralPathAppend, LiteralPath
Aliases: PSPath

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NoClobber

Prevents an existing file from being overwritten and displays a message that the file already exists.

```yaml
Type: SwitchParameter
Parameter Sets: PathNoClobber, LiteralPathNoClobber
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru

Returns the path for each log that the cmdlet started.

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

### -Path

Specifies a path to the log file. Wildcards are accepted.

```yaml
Type: String[]
Parameter Sets: Path, PathNoClobber, PathAppend
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String

You can pipe a string that contains a path to this cmdlet.

## OUTPUTS

### None, String

This cmdlet generates a string value that represents the path, if you specify the PassThru parameter. Otherwise, this cmdlet does not generate any output.

## NOTES

The InformationVariable, WarningVariable, and ErrorVariable parameters of the corresponding `Write-Information`, `Write-Warning,` and `Write-Error` cmdlets are used to determine messages written to the PowerShell log. A specific message(s) can be excluded by using the correct parameter with a variable or null as show below.

Write-Information -InformationVariable null
Write-Warning -WarningVariable null
Write-Error -ErrorVariable null

## RELATED LINKS

[None]()
