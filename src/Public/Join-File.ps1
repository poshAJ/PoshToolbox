function Join-File {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding(
        DefaultParameterSetName = 'Path',
        SupportsShouldProcess
    )]
    [OutputType([System.IO.FileInfo])]

    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0,
            ParameterSetName = 'Path'
        )]
        [ValidateScript({
                if (Test-Path -Path $_ -PathType 'Leaf' -Filter '*.*split') {
                    return $true
                }
                throw 'The argument specified must resolve to a valid split type file.'
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
                if (Test-Path -LiteralPath $_ -PathType 'Leaf' -Filter '*.*split') {
                    return $true
                }
                throw 'The argument specified must resolve to a valid split type file.'
            })]
        [PoshToolbox.FileSystemLiteralPathTransformation()]
        [System.IO.FileInfo[]] $LiteralPath,

        [Parameter()]
        [PoshToolbox.ReturnFirstOrInputTransformation()]
        [PoshToolbox.FileSystemLiteralPathTransformation()]
        [System.IO.DirectoryInfo] $Destination = (Get-Location -PSProvider 'FileSystem').Path
    )

    ## LOGIC ###################################################################
    process {
        foreach ($Object in $PSBoundParameters[$PSCmdlet.ParameterSetName]) {
            try {
                [System.Collections.Generic.Dictionary[string, System.IDisposable]] $Disposable = @{}

                [string] $CalculatedDestination = if ($Destination.Extension) { $Destination } else { "$( $Destination.FullName.TrimEnd('/\') )/$( $Object.BaseName )" }

                if ($PSCmdlet.ShouldProcess($CalculatedDestination, 'Write Content')) {
                    [string] $Directory = if ($Destination.Extension) { $Destination.Parent } else { $Destination }

                    if (-not $Directory.Exists) { $null = [System.IO.Directory]::CreateDirectory($Directory) }

                    $PSCmdlet.WriteVerbose("WRITE ${CalculatedDestination}")

                    $Disposable.Writer = [System.IO.File]::OpenWrite($CalculatedDestination)
                    # sort to fix ChildItem number sorting
                    foreach ($SplitFile in (Get-ChildItem -Path "$( $Object.Directory )/$( $Object.BaseName ).*split").FullName | Sort-Object -Property { [int32] [regex]::Match($_, '\.(?<match>\d+)split$').Groups['match'].Value }) {
                        $PSCmdlet.WriteVerbose("READ ${SplitFile}")

                        [byte[]] $Bytes = [System.IO.File]::ReadAllBytes($SplitFile)
                        $Disposable.Writer.Write($Bytes, 0, $Bytes.Length)
                    }
                }

                $PSCmdlet.WriteObject(( Get-ChildItem -Path $CalculatedDestination ))
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
