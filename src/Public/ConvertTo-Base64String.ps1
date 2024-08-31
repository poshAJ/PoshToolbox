function ConvertTo-Base64String {
    # Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
    [CmdletBinding()]
    [OutputType([string])]

    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            Position = 0
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

            $Disposable.MemoryWriter = [System.IO.MemoryStream]::new()

            try {
                [byte[]] $Buffer = $InputObject
            } catch {
                if ($InputObject -is [string]) {
                    [byte[]] $Buffer = [System.Text.Encoding]::UTF8.GetBytes($InputObject)
                } else {
                    [xml] $Serialize = [System.Management.Automation.PSSerializer]::Serialize($InputObject, $Depth)

                    [byte[]] $Buffer = [System.Text.Encoding]::UTF8.GetBytes($Serialize.OuterXml)
                }
            }

            $Disposable.MemoryWriter.Write($Buffer, 0, $Buffer.Length)

            $Disposable.MemoryWriter.Flush()
            $Disposable.MemoryWriter.Position = 0

            $Disposable.CryptoStream = [System.Security.Cryptography.CryptoStream]::new(
                $Disposable.MemoryWriter,
                [System.Security.Cryptography.ToBase64Transform]::new(),
                [System.Security.Cryptography.CryptoStreamMode]::Read
            )

            $Disposable.MemoryReader = [System.IO.MemoryStream]::new()
            $Disposable.CryptoStream.CopyTo($Disposable.MemoryReader)

            [byte[]] $Bytes = $Disposable.MemoryReader.ToArray()
            [string] $String = [System.Console]::OutputEncoding.GetString($Bytes)

            $PSCmdlet.WriteObject($String)
        } catch [System.Management.Automation.MethodInvocationException] {
            $PSCmdlet.WriteError(( New_MethodInvocationException -Exception $_.Exception.InnerException ))
        } catch {
            $PSCmdlet.WriteError($_)
        } finally {
            $Disposable.Values.Dispose()
        }
    }
}
