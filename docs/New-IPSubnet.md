---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://github.com/PoshAJ/PoshToolbox/blob/main/docs/New-IPSubnet.md
schema: 2.0.0
---

# New-IPSubnet

## SYNOPSIS
Creates an IPSubnet object.

## SYNTAX

### InputObject
```
New-IPSubnet [-InputObject] <String[]> [<CommonParameters>]
```

### IPAddress
```
New-IPSubnet -IPAddress <String> -IPPrefix <Int32> [<CommonParameters>]
```

## DESCRIPTION
The `New-IPSubnet` cmdlet creates an IPSubnet object that represents a set of IP addresses.

## EXAMPLES

## PARAMETERS

### -InputObject
Specifies an IP subnet in CIDR notation.

```yaml
Type: String[]
Parameter Sets: InputObject
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -IPAddress
Specifies an IP address in dotted-quad notation for IPv4 and in colon-hexadecimal notation for IPv6.

```yaml
Type: String
Parameter Sets: IPAddress
Aliases: Address

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPPrefix
Specifies an IP prefix as the number of bits within the host section of the IP address.

```yaml
Type: Int32
Parameter Sets: IPAddress
Aliases: Prefix

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String
You can pipe a string that contains an IP subnet in CIDR notation to this cmdlet.

## OUTPUTS

### System.Net.IPSubnet
Returns an object representing the IP subnet.

## NOTES

## RELATED LINKS

[None]()
