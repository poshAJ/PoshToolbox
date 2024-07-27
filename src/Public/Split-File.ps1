function Split-File {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.IO.FileInfo])]
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

                [System.Collections.Generic.Dictionary[string, System.IDisposable]] $Disposable = @{}

                [System.IO.FileInfo] $File = $Object.ProviderPath

                $PSCmdlet.WriteVerbose("READ ${File}")

                $Disposable.Reader = [System.IO.File]::OpenRead($File)
                [byte[]] $Buffer = [byte[]]::new($Size)
                [int32] $Count = 1

                [string] $CalculatedDestination = if ($DestinationInfo.Extension) { "$( $DestinationInfo.Directory.FullName )/$( $File.Name )" } else { "$( $DestinationInfo.FullName.TrimEnd('\/') )/$( $File.Name )" }

                while ([int32] $Read = $Disposable.Reader.Read($Buffer, 0, $Buffer.Length)) {
                    if ($Read -ne $Buffer.Length) {
                        [array]::Resize([ref] $Buffer, $Read)
                    }

                    [string] $SplitFile = "${CalculatedDestination}.${Count}split"
                    if ($PSCmdlet.ShouldProcess($SplitFile, 'Write Content')) {
                        [string] $Directory = if ($DestinationInfo.Extension) { $DestinationInfo.Directory } else { $DestinationInfo }

                        if (-not $Directory.Exists) { $null = [System.IO.Directory]::CreateDirectory($Directory) }

                        $PSCmdlet.WriteVerbose("WRITE ${SplitFile}")

                        [System.IO.File]::WriteAllBytes($SplitFile, $Buffer)
                    }

                    $Count++
                }

                # sort to fix ChildItem number sorting
                $PSCmdlet.WriteObject(( Get-ChildItem -Path "${CalculatedDestination}.*split" | Sort-Object -Property { [int32] [regex]::Match($_.FullName, '\.(?<match>\d+)split$').Groups['match'].Value } ))
            } catch [System.Management.Automation.MethodInvocationException] {
                $PSCmdlet.WriteError(( New_MethodInvocationException -Exception $_.Exception.InnerException ))
            } catch {
                $PSCmdlet.WriteError($_)
            } finally {
                $Disposable.Values.Dispose()
            }
        }
    }
}
