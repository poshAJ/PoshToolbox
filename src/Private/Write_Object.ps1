function Write_Object {
    # Copyright (c) 2024 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([object])]
    param (
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [object] $InputObject
    )

    ## LOGIC ###################################################################
    end {
        if ($InputObject -is [scriptblock]) {
            . $InputObject
        } else {
            $PSCmdlet.WriteObject($InputObject)
        }
    }
}
