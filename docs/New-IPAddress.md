---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://github.com/PoshAJ/PoshToolbox/blob/main/docs/New-IPAddress.md
schema: 2.0.0
---

# New-IPAddress

## SYNOPSIS
Creates an IPAddress object.

## SYNTAX

```
New-IPAddress [-IPAddress] <String[]> [<CommonParameters>]
```

## DESCRIPTION
The `New-IPAddress` cmdlet creates a System.Net.IPAddress object that represents an IP address.

## EXAMPLES

## PARAMETERS

### -IPAddress
Specifies an IP address in dotted-quad notation for IPv4 and in colon-hexadecimal notation for IPv6.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Address

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String
You can pipe an IP Address as a string to this cmdlet.

## OUTPUTS

### System.Net.IPAddress
Returns an object representing the IP Address.

## NOTES

## RELATED LINKS

[None]()
