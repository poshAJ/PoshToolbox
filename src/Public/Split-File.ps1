function Split-File {
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
                if (Test-Path -Path $_ -PathType 'Leaf') {
                    return $true
                }
                throw 'The argument specified must resolve to a valid file path.'
            })]
        [string[]] $Path,

        [Alias('PSPath')]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'LiteralPath'
        )]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -PathType 'Leaf') {
                    return $true
                }
                throw 'The argument specified must resolve to a valid file path.'
            })]
        [string[]] $LiteralPath,

        [Parameter()]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -IsValid) {
                    return $true
                }
                throw 'The argument specified must resolve to a valid file or folder path.'
            })]
        [string]
        $Destination = (Get-Location -PSProvider 'FileSystem').ProviderPath,

        [Parameter (
            Mandatory
        )]
        [ValidateRange(0, [int32]::MaxValue)]
        [int32] $Size
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

                $PSCmdlet.WriteVerbose("READ ${File}")

                Use-Object ([System.IO.FileStream] $Reader = [System.IO.File]::OpenRead($File)) {
                    [byte[]] $Buffer = [byte[]]::new($Size)
                    [int32] $Count = 1

                    [string] $CalculatedDestination = $DestinationInfo.Extension | Use-Ternary "$( $DestinationInfo.Directory.FullName )/$( $File.Name )" "$( $DestinationInfo.FullName.TrimEnd('\/') )/$( $File.Name )"

                    while ([int32] $Read = $Reader.Read($Buffer, 0, $Buffer.Length)) {
                        if ($Read -ne $Buffer.Length) {
                            [array]::Resize([ref] $Buffer, $Read)
                        }

                        [string] $SplitFile = "${CalculatedDestination}.${Count}split"
                        if ($PSCmdlet.ShouldProcess($SplitFile, 'Write Content')) {
                            if (-not ([string] $Directory = $DestinationInfo.Extension | Use-Ternary $DestinationInfo.Directory $DestinationInfo).Exists) {
                                $null = [System.IO.Directory]::CreateDirectory($Directory)
                            }

                            $PSCmdlet.WriteVerbose("WRITE ${SplitFile}")

                            [System.IO.File]::WriteAllBytes($SplitFile, $Buffer)
                        }

                        $Count++
                    }

                    # sort to fix ChildItem number sorting
                    $PSCmdlet.WriteObject(( Get-ChildItem -Path "${CalculatedDestination}.*split" | Sort-Object -Property { [int32] [regex]::Match($_.FullName, '\.(?<match>\d+)split$').Groups['match'].Value } ))
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
