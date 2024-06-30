function Join-File {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([object])]
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Path'
        )]
        [ValidateScript({
                if (Test-Path -Path $_ -PathType 'Leaf' -Filter '*.*split') {
                    return $true
                }
                throw 'The argument specified must resolve to a valid split type file.'
            })]
        [string[]] $Path,

        [Alias('PSPath')]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'LiteralPath'
        )]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -PathType 'Leaf' -Filter '*.*split') {
                    return $true
                }
                throw 'The argument specified must resolve to a valid split type file.'
            })]
        [string[]] $LiteralPath,

        [Parameter()]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -IsValid) {
                    return $true
                }
                throw 'The argument specified must resolve to a valid file or folder path.'
            })]
        [string] $Destination = (Get-Location -PSProvider 'FileSystem').ProviderPath
    )

    ## LOGIC ###################################################################
    begin {
        [System.IO.FileInfo] $DestinationInfo = (Resolve-PoshPath -LiteralPath $Destination).ProviderPath
    }

    process {
        [hashtable] $Splat = @{ $PSCmdlet.ParameterSetName = $PSBoundParameters[$PSCmdlet.ParameterSetName] }
        [object] $Process = Resolve-PoshPath @Splat

        foreach ($Object in $Process) {
            try {
                if ($Object.Provider.Name -ne 'FileSystem') {
                    New_ArgumentException 'The argument specified must resolve to a valid path on the FileSystem provider.' -Throw
                }

                [System.IO.FileInfo] $File = $Object.ProviderPath

                [string] $CalculatedDestination = $DestinationInfo.Extension | Use-Ternary $DestinationInfo "$( $DestinationInfo.FullName.TrimEnd('\/') )/$( $File.BaseName )"

                if ($PSCmdlet.ShouldProcess($CalculatedDestination, 'Write Content')) {
                    if (-not ([string] $Directory = $DestinationInfo.Extension | Use-Ternary $DestinationInfo.Directory $DestinationInfo).Exists) {
                        $null = [System.IO.Directory]::CreateDirectory($Directory)
                    }

                    $PSCmdlet.WriteVerbose("WRITE ${CalculatedDestination}")

                    Use-Object ([System.IO.FileStream] $Writer = [System.IO.File]::OpenWrite($CalculatedDestination)) {
                        # sort to fix ChildItem number sorting
                        foreach ($SplitFile in (Get-ChildItem -Path "$( $File.Directory )/$( $File.BaseName ).*split").FullName | Sort-Object -Property { [int32] [regex]::Match($_, '\.(?<match>\d+)split$').Groups['match'].Value }) {
                            $PSCmdlet.WriteVerbose("READ ${SplitFile}")

                            [byte[]] $Bytes = [System.IO.File]::ReadAllBytes($SplitFile)
                            $Writer.Write($Bytes, 0, $Bytes.Length)
                        }
                    }
                }

                $PSCmdlet.WriteObject(( Get-ChildItem -Path $CalculatedDestination ))

                ## EXCEPTIONS ##################################################
            } catch [System.Management.Automation.MethodInvocationException] {
                $PSCmdlet.WriteError(( New_MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
