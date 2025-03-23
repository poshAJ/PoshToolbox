# Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

class IPSubnet : System.Object {
    ## PROPERTIES #############################################################
    [System.Net.IPAddress] $Network
    [System.Net.Sockets.AddressFamily] $AddressFamily
    [int] $Prefix
    [System.Net.IPAddress] $SubnetMask
    [System.Net.IPAddress] $LastAddress

    [bigint] hidden $PrefixInt
    [bigint] hidden $StartInt
    [bigint] hidden $EndInt

    ## METHODS ################################################################
    static [IPSubnet] Parse([System.Net.IPAddress] $IPAddress, [int] $Prefix) {
        return ([IPSubnet]::new($IPAddress, $Prefix))
    }

    static [bool] TryParse([object] $IPAddress, [object] $Prefix, [ref] $Variable) {
        try {
            $Variable.Value = [IPSubnet]::new($IPAddress, $Prefix)

            return $true
        } catch {
            return $false
        }
    }

    [string] ToString() {
        return ("{0}/{1}" -f $this.Network, $this.Prefix)
    }

    [bool] Contains([System.Net.IPAddress] $IPAddress) {
        $ContainsAddress = $this.ToAddress($IPAddress, $false) -band $this.PrefixInt
        $NetworkAddress = $this.ToAddress($this.Network, $false)

        return ($NetworkAddress -eq $ContainsAddress)
    }

    [IPSubnet[]] Subnet([int] $Prefix) {
        $Power = switch ($this.AddressFamily) {
            "InterNetwork" { [bigint]::Pow(2, (32 - $Prefix)) }
            "InterNetworkV6" { [bigint]::Pow(2, (128 - $Prefix)) }
        }

        $Subnets = for ($AddressInt = $this.StartInt; $AddressInt -le $this.EndInt; $AddressInt += $Power) {
            [IPSubnet]::new(($this.FromAddress($AddressInt, $true)), $Prefix)
        }

        return $Subnets
    }

    [bigint] hidden ToAddress([System.Net.IPAddress] $IPAddress, [bool] $Reverse) {
        [byte[]] $Bytes = $IPAddress.GetAddressBytes()

        if ($Reverse) {
            [array]::Reverse($Bytes)
        }

        return ([bigint]::new($Bytes + 0))
    }

    [System.Net.IPAddress] hidden FromAddress([bigint] $BigInt, [bool] $Reverse) {
        [byte[]] $Bytes = $BigInt.ToByteArray()

        switch ($this.AddressFamily) {
            "InterNetwork" { [array]::Resize([ref] $Bytes, 4) }
            "InterNetworkV6" { [array]::Resize([ref] $Bytes, 16) }
        }

        if ($Reverse) {
            [array]::Reverse($Bytes)
        }

        return ([System.Net.IPAddress] $Bytes)
    }

    [bigint] hidden GetPrefixInt([int] $Int) {
        $Binary = switch ($this.AddressFamily) {
            "InterNetwork" { ('1' * $Int).PadRight(32, '0') }
            "InterNetworkV6" { ('1' * $Int).PadRight(128, '0') }
        }

        $Bytes = $Binary -isplit "(?<byte>[01]{8})", 0, "ExplicitCapture" |
            Where-Object { $_ } | ForEach-Object { [System.Convert]::ToUInt32($_, 2) }

        # append zero byte for unsigned
        return ([bigint]::new($Bytes + 0))
    }

    ## CONSTRUCTORS ###########################################################
    IPSubnet([System.Net.IPAddress] $IPAddress, [int] $Prefix) {
        $this.Prefix = $Prefix
        $this.AddressFamily = $IPAddress.AddressFamily

        switch ($true) {
            { $this.AddressFamily -eq "InterNetwork" -and $this.Prefix -iin 0..32 } { continue }
            { $this.AddressFamily -eq "InterNetworkV6" -and $this.Prefix -iin 0..128 } { continue }
            default { throw ([System.InvalidCastException] "An invalid prefix for the given address family was specified.") }
        }

        $this.PrefixInt = $this.GetPrefixInt($this.Prefix)
        $this.SubnetMask = $this.FromAddress($this.PrefixInt, $false)

        $StartAddress = $this.ToAddress($IPAddress, $false) -band $this.PrefixInt
        $this.Network = $this.FromAddress($StartAddress, $false)

        $EndAddress = switch ($this.AddressFamily) {
            "InterNetwork" { $StartAddress -bor (-bnot $this.PrefixInt -band ([bigint]::Pow(2, 32) - 1)) }
            "InterNetworkV6" { $StartAddress -bor (-bnot $this.PrefixInt -band ([bigint]::Pow(2, 128) - 1)) }
        }
        $this.LastAddress = $this.FromAddress($EndAddress, $false)

        $this.StartInt = $this.ToAddress($this.Network, $true)
        $this.EndInt = $this.ToAddress($this.LastAddress, $true)
    }
}
