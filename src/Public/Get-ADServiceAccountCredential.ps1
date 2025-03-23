function Get-ADServiceAccountCredential {
    # Copyright (c) 2021 Ryan Ephgrave, https://github.com/Ryan2065/gMSACredentialModule
    # Modified "Get-GMSACredential.ps1" by Anthony J. Raymond
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '',
        Justification = 'Retrieved password is plaintext.')]

    [CmdletBinding()]
    [OutputType([pscredential])]
    param (
        [Alias('distinguishedName', 'objectGuid', 'objectSid', 'sAMAccountName')]
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $Identity,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Server
    )

    ## LOGIC ###################################################################
    begin {
        [hashtable[]] $Properties = @(
            @{ n = 'sAMAccountName'; e = { $_.Properties.'samaccountname' } }
            @{ n = 'Length'; e = { $_.Properties.'msds-managedpassword'.Length } }
            @{ n = 'ManagedPassword'; e = {
                    [int32] $Length = $_.Properties.'msds-managedpassword'.Length
                    [int32] $IntPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Length)

                    [System.Runtime.InteropServices.Marshal]::Copy([byte[]] $_.Properties.'msds-managedpassword'.ForEach{ $_ }, 0, $IntPtr, $Length)

                    return $IntPtr
                }
            }
        )
    }

    process {
        foreach ($Object in $Identity) {
            try {
                [System.Collections.Generic.Dictionary[string, System.IDisposable]] $Disposable = @{}

                try {
                    # https://ldapwiki.com/wiki/ObjectGuid
                    [string] $ObjectGuid = ([guid] $Object).ToByteArray().ForEach{ $_.ToString('X2') } -join '\'
                    [string] $Filter = "(&(objectGuid=\${ObjectGuid})(ObjectCategory=msDS-GroupManagedServiceAccount))"
                } catch {
                    [string] $Filter = '(&(|(distinguishedName={0})(objectSid={0})(sAMAccountName={1}))(ObjectCategory=msDS-GroupManagedServiceAccount))' -f $Object, ($Object -ireplace '[^$]$', '$&$')
                }

                $Disposable.DirectorySearcher = [System.DirectoryServices.DirectorySearcher]::new($Filter)
                if ($Server) { $Disposable.DirectorySearcher.SearchRoot = "LDAP://${Server}" }

                $Disposable.DirectorySearcher.SearchRoot.AuthenticationType = 'Sealing'
                $Disposable.DirectorySearcher.PropertiesToLoad.AddRange(@('sAMAccountName', 'msDS-ManagedPassword'))

                [object] $ADServiceAccount = $Disposable.DirectorySearcher.FindOne() | Select-Object -Property $Properties

                if (-not $ADServiceAccount) {
                    New_ActiveDirectoryObjectNotFoundException -Message "Cannot find an object with identity: '${Object}' under: '$( $Disposable.DirectorySearcher.SearchRoot.distinguishedName )'." -Throw
                } elseif ($ADServiceAccount.Length -eq 0) {
                    New_ActiveDirectoryOperationException -Message 'Cannot retrieve service account password. A process has requested access to an object, but has not been granted those access rights.' -Throw
                }

                # https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/a9019740-3d73-46ef-a9ae-3ea8eb86ac2e
                [securestring] $SecureString = ConvertTo-SecureString -String ([System.Runtime.InteropServices.Marshal]::PtrToStringUni([int64] $ADServiceAccount.ManagedPassword + 16)) -AsPlainText -Force

                $PSCmdlet.WriteObject([pscredential]::new($ADServiceAccount.sAMAccountName, $SecureString))
            } catch [System.Management.Automation.SetValueInvocationException] {
                $PSCmdlet.WriteError(( New_ActiveDirectoryServerDownException -Message 'Unable to contact the server. This may be because this server does not exist, it is currently down, or it does not have the Active Directory Services running.' ))
            } catch {
                $PSCmdlet.WriteError($_)
            } finally {
                $Disposable.Values.Dispose()

                if ($ADServiceAccount) {
                    [System.Runtime.InteropServices.Marshal]::Copy([byte[]]::new($ADServiceAccount.Length), 0, $ADServiceAccount.ManagedPassword, $ADServiceAccount.Length)
                    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($ADServiceAccount.ManagedPassword)

                    $ADServiceAccount = $SecureString = $null
                    $null = [System.GC]::GetTotalMemory($true)
                }
            }
        }
    }
}
