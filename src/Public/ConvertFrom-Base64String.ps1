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
        [string[]] $InputObject
    )

    ## LOGIC ###################################################################
    process {
        foreach ($Object in $InputObject) {
            try {
                [System.Collections.Generic.Dictionary[string, System.IDisposable]] $Disposable = @{}

                $Disposable.MemoryStream = [System.IO.MemoryStream]::new()

                $Disposable.MemoryStream.Write([System.Console]::InputEncoding.GetBytes($Object))

                $Disposable.MemoryStream.Flush()
                $Disposable.MemoryStream.Position = 0

                $Disposable.CryptoStream = [System.Security.Cryptography.CryptoStream]::new(
                    $Disposable.MemoryStream,
                    [System.Security.Cryptography.FromBase64Transform]::new(),
                    [System.Security.Cryptography.CryptoStreamMode]::Read
                )

                $Disposable.StreamReader = [System.IO.StreamReader]::new(
                    $Disposable.CryptoStream,
                    [System.Text.Encoding]::Unicode
                )

                [string] $String = $Disposable.StreamReader.ReadToEnd()

                try {
                    $PSCmdlet.WriteObject([System.Management.Automation.PSSerializer]::Deserialize($String))
                } catch {
                    $PSCmdlet.WriteObject([System.Text.Encoding]::Unicode.GetBytes($String))
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
