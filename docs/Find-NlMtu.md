---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://github.com/PoshAJ/PoshToolbox/blob/main/docs/Find-NlMtu.md
schema: 2.0.0
---

# Find-NlMtu

## SYNOPSIS
Discovers the network layer maximum transmission unit (MTU) size.

## SYNTAX

```
Find-NlMtu [-ComputerName] <String[]> [-Timeout <Int32>] [-MaxHops <Int32>] [<CommonParameters>]
```

## DESCRIPTION
The `Find-NlMtu` cmdlet creates a result object for the specified computer name(s) by evaluating the response to Internet Control Message Protocol (ICMP) echo request packets.

## EXAMPLES

## PARAMETERS

### -ComputerName
Specifies the Domain Name System (DNS) name or IP address of the target computer.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Hostname, IPAddress, Address

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -MaxHops
Sets the maximum number of hops that an ICMP request message can be sent.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Ttl, TimeToLive, Hops

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Sets the timeout value in milliseconds for the ping tests.

```yaml
Type: Int32
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

### String
You can pipe a computer name as a string to this cmdlet.

## OUTPUTS

### PSObject
Returns a result object for each specified computer name.

## NOTES

## RELATED LINKS

[None]()
