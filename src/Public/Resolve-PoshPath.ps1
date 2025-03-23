function Resolve-PoshPath {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([PoshToolbox.ResolvePoshPathCommand+PoshPathInfo])]
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Path'
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $Path,

        [Alias('PSPath')]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'LiteralPath'
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $LiteralPath
    )

    ## LOGIC ###################################################################
    process {
        foreach ($PSPath in $PSBoundParameters[$PSCmdlet.ParameterSetName]) {
            try {
                if ($PSCmdlet.ParameterSetName -eq 'Path') {
                    try {
                        [string[]] $PSPath = $PSCmdlet.SessionState.Path.GetResolvedPSPathFromPSPath($PSPath)
                    } catch [System.Management.Automation.MethodInvocationException] {
                        [string[]] $PSPath = $_.Exception.InnerException.ItemName
                    }
                }

                foreach ($String in $PSPath) {
                    [System.Management.Automation.ProviderInfo] $Provider = [System.Management.Automation.PSDriveInfo] $Drive = $null
                    [string] $ProviderPath = $PSCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($String, [ref] $Provider, [ref] $Drive)

                    $PSCmdlet.WriteObject(
                        [PoshToolbox.ResolvePoshPathCommand+PoshPathInfo]::new(
                            $String,
                            $ProviderPath,
                            $Provider,
                            $Drive
                        )
                    )
                }
            } catch [System.Management.Automation.MethodInvocationException] {
                $PSCmdlet.WriteError(( New_MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
