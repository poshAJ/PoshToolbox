function ConvertTo-Base64String {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [object] $InputObject,

        [Parameter()]
        [int32] $Depth = 2
    )

    ## LOGIC ###################################################################
    process {
        try {
            try {
                [byte[]] $Bytes = $InputObject
            } catch {
                [xml] $Serialize = [System.Management.Automation.PSSerializer]::Serialize($InputObject, $Depth)
                [byte[]] $Bytes = $Serialize.OuterXml.ToCharArray()

                $PSCmdlet.WriteDebug($Serialize.OuterXml)
            }

            $PSCmdlet.WriteObject([System.Convert]::ToBase64String($Bytes))

            ## EXCEPTIONS ######################################################
        } catch [System.Management.Automation.MethodInvocationException] {
            $PSCmdlet.WriteError(( New_MethodInvocationException -Exception $_.Exception.InnerException ))
        } catch {
            $PSCmdlet.WriteError($_)
        }
    }
}
