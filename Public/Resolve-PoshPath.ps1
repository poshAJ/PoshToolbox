# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

function Resolve-PoshPath {
    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline,
            ParameterSetName = "Path"
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "LiteralPath"
        )]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $LiteralPath
    )

    ## PROCESS ################################################################
    process {
        foreach ($Object in ($Path + $LiteralPath).Where({ $_ })) {
            try {
                if ($PSCmdlet.ParameterSetName -eq "Path") {
                    try {
                        $Object = $PSCmdlet.SessionState.Path.GetResolvedPSPathFromPSPath($Object)
                    } catch {
                        $Parent = Split-Path $_.Exception.InnerException.ItemName -Parent
                        $Leaf = Split-Path $_.Exception.InnerException.ItemName -Leaf

                        if ($Parent) {
                            $Object = $PSCmdlet.SessionState.Path.GetResolvedPSPathFromPSPath($Parent).ForEach({ $_.TrimEnd("\") + "\" + $Leaf })
                        } else {
                            throw $_
                        }
                    }
                }

                foreach ($String in $Object) {
                    $ProviderInfo = $DriveInfo = $null
                    $ProviderPath = $PSCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($String, [ref] $ProviderInfo, [ref] $DriveInfo)

                    Write-Output ([pscustomobject] @{
                            ProviderPath = $ProviderPath
                            Provider     = $ProviderInfo
                            Drive        = $DriveInfo
                        })
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
