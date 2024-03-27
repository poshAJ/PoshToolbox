function Write_Object {
    # Copyright (c) 2024 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS ##############################################################
    param (
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [object]
        $InputObject
    )

    ## END #####################################################################
    end {
        if ($InputObject -is [scriptblock]) {
            $InputObject.InvokeReturnAsIs()
        } else {
            Write-Output (, $InputObject)
        }
    }
}
