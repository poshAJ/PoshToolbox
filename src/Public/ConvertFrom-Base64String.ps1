function ConvertFrom-Base64String {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([object])]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -notmatch '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$') {
                    throw 'The argument specified must be a valid base 64 string.'
                }
                return $true
            })]
        [string[]] $InputObject,

        [Parameter()]
        [switch] $AsString = $false
    )

    ## LOGIC ###################################################################
    process {
        foreach ($Object in $InputObject) {
            try {
                [System.Collections.Generic.Dictionary[string, System.IDisposable]] $Disposable = @{}

                $Disposable.MemoryWriter = [System.IO.MemoryStream]::new()

                $Disposable.MemoryWriter.Write(([byte[]] $Buffer = [System.Console]::InputEncoding.GetBytes($Object)), 0, $Buffer.Length)

                $Disposable.MemoryWriter.Flush()
                $Disposable.MemoryWriter.Position = 0

                $Disposable.CryptoStream = [System.Security.Cryptography.CryptoStream]::new(
                    $Disposable.MemoryWriter,
                    [System.Security.Cryptography.FromBase64Transform]::new(),
                    [System.Security.Cryptography.CryptoStreamMode]::Read
                )

                $Disposable.MemoryReader = [System.IO.MemoryStream]::new()
                $Disposable.CryptoStream.CopyTo($Disposable.MemoryReader)

                [byte[]] $Bytes = $Disposable.MemoryReader.ToArray()
                [string] $String = [System.Text.Encoding]::UTF8.GetString($Bytes)

                if ($AsString) {
                    $PSCmdlet.WriteObject($String)
                } else {
                    try {
                        $PSCmdlet.WriteObject([System.Management.Automation.PSSerializer]::Deserialize($String))
                    } catch {
                        $PSCmdlet.WriteObject($Bytes)
                    }
                }
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
