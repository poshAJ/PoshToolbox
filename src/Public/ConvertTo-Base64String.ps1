function ConvertTo-Base64String {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [object] $InputObject,

        [Parameter()]
        [int32] $Depth = 2
    )

    ## LOGIC ###################################################################
    process {
        try {
            [System.Collections.Generic.Dictionary[string, System.IDisposable]] $Disposable = @{}

            $Disposable.MemoryStream = [System.IO.MemoryStream]::new()

            try {
                $Disposable.MemoryStream.Write(([byte[]] $Buffer = $InputObject), 0, $Buffer.Length)
            } catch {
                [xml] $Serialize = [System.Management.Automation.PSSerializer]::Serialize($InputObject, $Depth)

                $Disposable.MemoryStream.Write(([byte[]] $Buffer = [System.Text.Encoding]::Unicode.GetBytes($Serialize.OuterXml)), 0, $Buffer.Length)
            }

            $Disposable.MemoryStream.Flush()
            $Disposable.MemoryStream.Position = 0

            $Disposable.CryptoStream = [System.Security.Cryptography.CryptoStream]::new(
                $Disposable.MemoryStream,
                [System.Security.Cryptography.ToBase64Transform]::new(),
                [System.Security.Cryptography.CryptoStreamMode]::Read
            )

            $Disposable.StreamReader = [System.IO.StreamReader]::new(
                $Disposable.CryptoStream,
                [System.Console]::OutputEncoding
            )

            $PSCmdlet.WriteObject($Disposable.StreamReader.ReadToEnd())
        } catch [System.Management.Automation.MethodInvocationException] {
            $PSCmdlet.WriteError(( New_MethodInvocationException -Exception $_.Exception.InnerException ))
        } catch {
            $PSCmdlet.WriteError($_)
        } finally {
            $Disposable.Values.Dispose()
        }
    }
}
