function Get-FolderProperties {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
        Justification = 'Named to match Windows context menu.')]

    [CmdletBinding()]
    [OutputType([PoshToolbox.GetFolderPropertiesCommand+FolderPropertiesInfo])]
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'Path'
        )]
        [ValidateScript({
                if (Test-Path -Path $_ -PathType 'Container') {
                    return $true
                }
                throw 'The argument specified must resolve to a valid folder path.'
            })]
        [PoshToolbox.FileSystemPathTransformation()]
        [System.IO.DirectoryInfo[]] $Path,

        [Alias('PSPath')]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName = 'LiteralPath'
        )]
        [ValidateScript({
                if (Test-Path -LiteralPath $_ -PathType 'Container') {
                    return $true
                }
                throw 'The argument specified must resolve to a valid folder path.'
            })]
        [PoshToolbox.FileSystemLiteralPathTransformation()]
        [System.IO.DirectoryInfo[]] $LiteralPath,

        [Parameter()]
        [ValidateSet(
            'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB', # Decimal Metric (Base 10)
            'KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB' # Binary IEC (Base 2)
        )]
        [string] $Unit
    )

    ## LOGIC ###################################################################
    begin {
        [string[]] $Suffixes = @(
            'B' # byte
            'KB'   # kilo
            'MB'   # mega
            'GB'   # giga
            'TB'   # tera
            'PB'   # peta
            'EB'   # exa
            'ZB'   # zetta
            'YB'   # yotta
        )
    }

    process {
        foreach ($Object in $PSBoundParameters[$PSCmdlet.ParameterSetName]) {
            try {
                $PSCmdlet.WriteVerbose("GET ${Object}")

                [int32] $Dirs = [int32] $Files = [int64] $Bytes = 0
                # https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
                [string[]] $Result = robocopy $Object.FullName.TrimEnd('/\') \\null /l /e /np /xj /r:0 /w:0 /bytes /nfl /ndl

                if (($LASTEXITCODE -eq 16) -and ($Result[-2] -eq 'Access is denied.')) {
                    New_UnauthorizedAccessException -Message "Access to the path '${Object}' is denied." -Throw
                } elseif ($LASTEXITCODE -eq 16) {
                    New_ArgumentException -Message "The specified path '${Object}' is invalid." -Throw
                }

                switch -Regex ($Result) {
                    'Dirs :\s+(?<match>\d+)' { $Dirs = $Matches.match - 1 }
                    'Files :\s+(?<match>\d+)' { $Files = $Matches.match }
                    'Bytes :\s+(?<match>\d+)' { $Bytes = $Matches.match }
                }

                # Copyright (c) 2021 Santiago Squarzon, https://github.com/santisq/PSTree, MIT License
                # Modified "src/PSTree/Internal/_FormattingInternals.cs" by Anthony J. Raymond
                [double] $Size = $Bytes
                [int32] $Base = if ($Unit -match 'i') { 1024 } else { 1000 }
                [int32] $Index = 0
                [int32] $StopIndex = $Suffixes.IndexOf($Unit -replace 'i')

                while ((($StopIndex -eq -1) -and ($Size -ge $Base)) -or (($StopIndex -ne -1) -and ($Index -lt $StopIndex))) {
                    $Size /= $Base

                    $Index++
                }

                [string] $Suffix = if ($Unit) { $Unit } else { $Suffixes[$Index] }

                $PSCmdlet.WriteObject(
                    [PoshToolbox.GetFolderPropertiesCommand+FolderPropertiesInfo]::new(
                        $Object.FullName,
                        $Bytes,
                        "$( $Size.ToString('N2') ) ${Suffix}",
                        "${Files} Files, ${Dirs} Folders",
                        $Object.CreationTime
                    )
                )
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
