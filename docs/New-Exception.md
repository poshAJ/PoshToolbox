---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://github.com/PoshAJ/PoshToolbox/blob/main/docs/New-Exception.md
schema: 2.0.0
---

# New-Exception

## SYNOPSIS
Creates an instance of ErrorRecord.

## SYNTAX

```
New-Exception [-Message] <String> [-Throw] [<CommonParameters>]
```

## DESCRIPTION
The `New-Exception` cmdlet creates an ErrorRecord object for an exception with the specified message.

## EXAMPLES

## PARAMETERS

### -Message
Specifies the message text of the exception.

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

### -Throw
Specifies to generate a terminating error.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
You cannot pipe input to this cmdlet.

## OUTPUTS

### System.Management.Automation.ErrorRecord
Returns an ErrorRecord object for the specified message.

## NOTES

## RELATED LINKS

[None]()
