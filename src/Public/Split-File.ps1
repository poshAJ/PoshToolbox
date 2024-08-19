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
        [PoshToolbox.FileSystemPathTransformation()]
        [System.IO.FileInfo[]] $Path,

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
        [PoshToolbox.FileSystemLiteralPathTransformation()]
        [System.IO.FileInfo[]] $LiteralPath,

        [Parameter()]
        [PoshToolbox.ReturnFirstOrInputTransformation()]
        [PoshToolbox.FileSystemLiteralPathTransformation()]
        [System.IO.DirectoryInfo] $Destination = (Get-Location -PSProvider 'FileSystem').Path,

        [Parameter (
            Mandatory
        )]
        [ValidateRange(0, [int32]::MaxValue)]
        [int32] $Size
    )

    ## LOGIC ###################################################################
    process {
        foreach ($Object in $PSBoundParameters[$PSCmdlet.ParameterSetName]) {
            try {
                [System.Collections.Generic.Dictionary[string, System.IDisposable]] $Disposable = @{}

                $PSCmdlet.WriteVerbose("READ ${Object}")

                $Disposable.Reader = [System.IO.File]::OpenRead($Object)
                [byte[]] $Buffer = [byte[]]::new($Size)
                [int32] $Count = 1

                [string] $CalculatedDestination = if ($Destination.Extension) { "$( $Destination.Parent.FullName )/$( $Object.Name )" } else { "$( $Destination.FullName.TrimEnd('/\') )/$( $Object.Name )" }

                while ([int32] $Read = $Disposable.Reader.Read($Buffer, 0, $Buffer.Length)) {
                    if ($Read -ne $Buffer.Length) {
                        [array]::Resize([ref] $Buffer, $Read)
                    }

                    [string] $SplitFile = "${CalculatedDestination}.${Count}split"
                    if ($PSCmdlet.ShouldProcess($SplitFile, 'Write Content')) {
                        [string] $Directory = if ($Destination.Extension) { $Destination.Parent } else { $Destination }

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
