function Get-FolderProperties {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
        Justification = 'Named to match Windows context menu.')]

    [CmdletBinding()]
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
                if (Test-Path -Path $_ -PathType 'Container') {
                    return $true
                }
                throw 'The argument specified must resolve to a valid folder path.'
            })]
        [string[]] $Path,

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
        [string[]] $LiteralPath,

        [Parameter()]
        [ValidateSet(
            'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB', # Decimal Metric (Base 10)
            'KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB' # Binary IEC (Base 2)
        )]
        [string] $Unit = 'MiB'
    )

    ## LOGIC ###################################################################
    begin {
        [hashtable] $Prefix = @{
            [char] 'K' = 1 # kilo
            [char] 'M' = 2 # mega
            [char] 'G' = 3 # giga
            [char] 'T' = 4 # tera
            [char] 'P' = 5 # peta
            [char] 'E' = 6 # exa
            [char] 'Z' = 7 # zetta
            [char] 'Y' = 8 # yotta
        }

        [int32] $Base = $Unit.Contains('i') | Use-Ternary 1024 1000
        [double] $Divisor = [System.Math]::Pow($Base, $Prefix[$Unit[0]])
    }

    process {
        [hashtable] $Splat = @{ $PSCmdlet.ParameterSetName = $PSBoundParameters[$PSCmdlet.ParameterSetName] }
        [object] $Process = Resolve-PoshPath @Splat

        foreach ($Object in $Process) {
            try {
                if ($Object.Provider.Name -ne 'FileSystem') {
                    New_ArgumentException 'The argument specified must resolve to a valid path on the FileSystem provider.' -Throw
                }

                [System.IO.DirectoryInfo] $Folder = $Object.ProviderPath
                $PSCmdlet.WriteVerbose("GET ${Folder}")

                [int32] $Dirs = [int32] $Files = [int32] $Bytes = 0
                # https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
                [string[]] $Result = robocopy $Folder.FullName.TrimEnd('\') \\null /l /e /np /xj /r:0 /w:0 /bytes /nfl /ndl

                if (($LASTEXITCODE -eq 16) -and ($Result[-2] -eq 'Access is denied.')) {
                    New_UnauthorizedAccessException -Message "Access to the path '${Folder}' is denied." -Throw
                } elseif ($LASTEXITCODE -eq 16) {
                    New_ArgumentException -Message "The specified path '${Folder}' is invalid." -Throw
                }

                switch -Regex ($Result) {
                    'Dirs :\s+(?<match>\d+)' { $Dirs = [int32] $Matches.match - 1 }
                    'Files :\s+(?<match>\d+)' { $Files = [int32] $Matches.match }
                    'Bytes :\s+(?<match>\d+)' { $Bytes = [int64] $Matches.match }
                }

                $PSCmdlet.WriteObject(
                    [pscustomobject] @{
                        FullName = $Folder.FullName
                        Length   = $Bytes
                        Size     = "{0:n2} ${Unit}" -f ($Bytes / $Divisor)
                        Contains = "${Files} Files, ${Dirs} Folders"
                        Created  = '{0:F}' -f $Folder.CreationTime
                    }
                )
            } catch {
                $PSCmdlet.WriteError($_)
            }
        }
    }
}
