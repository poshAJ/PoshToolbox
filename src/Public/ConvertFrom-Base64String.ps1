function ConvertFrom-Base64String {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([object])]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $InputObject
    )

    ## LOGIC ###################################################################
    process {
        foreach ($Object in $InputObject) {
            try {
                [byte[]] $Bytes = [System.Convert]::FromBase64String($Object)

                try {
                    [string] $String = -join [char[]] $Bytes

                    $PSCmdlet.WriteObject([System.Management.Automation.PSSerializer]::Deserialize($String))
                } catch {
                    $PSCmdlet.WriteObject($Bytes)
                }

                ## EXCEPTIONS ##################################################
            } catch [System.Management.Automation.MethodInvocationException] {
                $PSCmdlet.WriteError(( New_MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
