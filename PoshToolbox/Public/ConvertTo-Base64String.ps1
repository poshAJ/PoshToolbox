# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

function ConvertTo-Base64String {
    [CmdletBinding()]
    [OutputType([string])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [object]
        $InputObject,

        [Parameter()]
        [int32]
        $Depth = 2
    )

    ## PROCESS ################################################################
    process {
        try {
            try {
                $Bytes = [byte[]] $InputObject
            } catch {
                $Serialize = [System.Management.Automation.PSSerializer]::Serialize($InputObject, $Depth)
                $Bytes = [byte[]] $Serialize.ToCharArray()
            }

            Write-Output ([System.Convert]::ToBase64String($Bytes))

            ## EXCEPTIONS #################################################
        } catch [System.Management.Automation.MethodInvocationException] {
            $PSCmdlet.WriteError(( New-MethodInvocationException -Exception $_.Exception.InnerException ))
        } catch {
            $PSCmdlet.WriteError($_)
        }
    }
}
