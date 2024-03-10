# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

function ConvertFrom-Base64String {
    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $InputObject
    )

    ## PROCESS ################################################################
    process {
        foreach ($Object in $InputObject) {
            try {
                $Bytes = [System.Convert]::FromBase64String($Object)

                try {
                    $String = -join [char[]] $Bytes

                    Write-Output ([System.Management.Automation.PSSerializer]::Deserialize($String))
                } catch {
                    Write-Output $Bytes
                }

                ## EXCEPTIONS #################################################
            } catch [System.Management.Automation.MethodInvocationException] {
                $PSCmdlet.WriteError(( New-MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
