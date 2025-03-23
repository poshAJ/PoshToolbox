---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://gitlab.com/PoshAJ/PoshToolbox/-/blob/main/docs/Use-ErrorCoalescing.md
schema: 2.0.0
---

# Use-ErrorCoalescing

## SYNOPSIS

Implements an Error-coalescing operator (?!).

## SYNTAX

```powershell
Use-ErrorCoalescing -InputObject <ScriptBlock> [[-IfError] <Object>] [<CommonParameters>]
```

## DESCRIPTION

The `Use-ErrorCoalescing` cmdlet simulates the effect of an error-coalescing operator.

An error-coalescing operator ?! returns the value of its left-hand operand if it isn't an error. Otherwise, it evaluates the right-hand operand and returns its result. The ?! operator doesn't evaluate its right-hand operand if the left-hand operand evaluates without error.

## EXAMPLES

## PARAMETERS

### -IfError

Specifies the expression to be executed if the \<condition\> expression is an error.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject

Specifies the \<condition\> expression to be evaluated and returned if not an error.

```yaml
Type: ScriptBlock
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

### ScriptBlock

You can pipe a scriptblock that represents the expression to be evaluated.

## OUTPUTS

### PSObject

Returns the output that is generated based on evaluating the expression.

## NOTES

## RELATED LINKS

[None]()
