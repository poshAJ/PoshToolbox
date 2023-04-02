# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)
# Copyright (c) 2021 Ryan Ephgrave, Modified Get-GMSACredential.ps1 (https://github.com/Ryan2065/gMSACredentialModule)

using namespace System.Security
using namespace System.Runtime.InteropServices
using namespace System.DirectoryServices

function Get-ADServiceAccountCredential {
    [CmdletBinding()]
    [OutputType([pscredential])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline
        )]
        [Alias("distinguishedName", "objectGUID", "objectSid", "sAMAccountName")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Identity,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Server
    )

    ## BEGIN ##################################################################
    begin {
        $Properties = @(
            @{n = "sAMAccountName"; e = { $_.Properties."samaccountname" } }
            @{n = "Length"; e = { $_.Properties."msds-managedpassword".Length } }
            @{n = "ManagedPassword"; e = {
                    $Length = $_.Properties."msds-managedpassword".Length
                    Write-Output ($IntPtr = [Marshal]::AllocHGlobal($Length))
                    [Marshal]::Copy([byte[]] $_.Properties."msds-managedpassword".ForEach({ $_ }), 0, $IntPtr, $Length)
                }
            }
        )
    }

    ## PROCESS ################################################################
    process {
        foreach ($Object in $Identity) {
            try {
                try {
                    # https://ldapwiki.com/wiki/ObjectGUID
                    $ObjectGUID = ([guid] $Object).ToByteArray().ForEach({ $_.ToString("X2") }) -join "\"
                    $Filter = "(&(objectGUID=\{0})(ObjectCategory=msDS-GroupManagedServiceAccount))" -f $ObjectGUID
                } catch {
                    $Filter = "(&(|(distinguishedName={0})(objectSid={0})(sAMAccountName={1}))(ObjectCategory=msDS-GroupManagedServiceAccount))" -f $Object, ($Object -ireplace "[^$]$", "$&$")
                }

                New-Variable -Name ADServiceAccount -Option AllScope

                Use-Object ($DirectorySearcher = [DirectorySearcher] $Filter) {
                    if ($Server) {
                        $DirectorySearcher.SearchRoot = [DirectoryEntry] ("LDAP://{0}" -f $Server)
                    }

                    $DirectorySearcher.SearchRoot.AuthenticationType = "Sealing"
                    $DirectorySearcher.PropertiesToLoad.AddRange(@("sAMAccountName", "msDS-ManagedPassword"))

                    $ADServiceAccount = $DirectorySearcher.FindOne() | Select-Object -Property $Properties

                    if (-not $ADServiceAccount) {
                        New-ActiveDirectoryObjectNotFoundException -Message ("Cannot find an object with identity: '{0}' under: '{1}'." -f $Object, $DirectorySearcher.SearchRoot.distinguishedName) -Throw
                    } elseif ($ADServiceAccount.Length -eq 0) {
                        New-ActiveDirectoryOperationException -Message "Cannot retrieve service account password. A process has requested access to an object, but has not been granted those access rights." -Throw
                    }
                }

                # https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/a9019740-3d73-46ef-a9ae-3ea8eb86ac2e
                $SecureString = ConvertTo-SecureString -String ([Marshal]::PtrToStringUni([int64] $ADServiceAccount.ManagedPassword + 16)) -AsPlainText -Force

                Write-Output ([pscredential]::new($ADServiceAccount.sAMAccountName, $SecureString))
                ## EXCEPTIONS #################################################
            } catch [SetValueInvocationException] {
                $PSCmdlet.WriteError((New-ActiveDirectoryServerDownException -Message "Unable to contact the server. This may be because this server does not exist, it is currently down, or it does not have the Active Directory Services running."))
            } catch {
                $PSCmdlet.WriteError($_)
            } finally {
                if ($ADServiceAccount) {
                    [Marshal]::Copy([byte[]]::new($ADServiceAccount.Length), 0, $ADServiceAccount.ManagedPassword, $ADServiceAccount.Length)
                    [Marshal]::FreeHGlobal($ADServiceAccount.ManagedPassword)

                    $ADServiceAccount = $SecureString = $null
                    $null = [GC]::GetTotalMemory($true)
                }
            }
        }
    }

    ## END ####################################################################
    end {
    }
}
