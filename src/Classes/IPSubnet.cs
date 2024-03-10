// Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

using System;
using System.Linq;
using System.Numerics;
using System.Net;
using System.Net.Sockets;
using System.Collections.Generic;

namespace System.Net
{
    public class IPSubnet
    {
        public IPAddress IPAddress { get; set; }
        public int NetworkPrefix
        {
            get { return this.prefix; }
            set
            {
                if ((this.AddressFamily == AddressFamily.InterNetwork && 0 <= value && value <= 32)
                || (this.AddressFamily == AddressFamily.InterNetworkV6 && 0 <= value && value <= 128))
                {
                    this.prefix = value;
                }
                else
                {
                    throw new ArgumentException("An invalid prefix for the address family was specified.");
                }
            }
        }
        public AddressFamily AddressFamily => this.IPAddress.AddressFamily;
        public IPAddress NetworkAddress => new IPAddress(this.start);
        public IPAddress SubnetMask => new IPAddress(this.mask);
        public IPAddress LastAddress => new IPAddress(this.end);
        private byte[] address => this.IPAddress.GetAddressBytes();
        private int prefix { get; set; }
        private byte[] mask => GetMask(this.prefix, this.address.Length);
        private byte[] start => GetStart(this.address, this.mask);
        private byte[] end => GetEnd(this.start, this.mask);

        public static IPSubnet Parse(string ipString, string prefixString)
        {
            IPAddress ip = IPAddress.Parse(ipString);
            int prefix = int.Parse(prefixString);

            return new IPSubnet(ip, prefix);
        }

        public static bool TryParse(string ipString, string prefixString, ref IPSubnet subnet)
        {
            try
            {
                subnet = IPSubnet.Parse(ipString, prefixString);

                return true;
            }
            catch
            {
                return false;
            }
        }

        public override string ToString()
        {
            return string.Format("{0}/{1}", this.NetworkAddress, this.NetworkPrefix);
        }

        public bool Contains(IPAddress ip)
        {
            if (ip.AddressFamily != this.AddressFamily)
            {
                return false;
            }

            return this.start.SequenceEqual(IPSubnet.GetStart(ip.GetAddressBytes(), this.mask));
        }

        public IPSubnet[] Split(int prefix)
        {
            List<IPSubnet> subnets = new List<IPSubnet>();

            BigInteger i = new BigInteger(IPSubnet.ReverseBytes(this.start));
            BigInteger j = new BigInteger(IPSubnet.ReverseBytes(this.end));

            BigInteger inc = BigInteger.Pow(2, this.mask.Length * 8 - prefix);

            for (; i <= j; i += inc)
            {
                byte[] b = IPSubnet.ReverseBytes(i.ToByteArray());
                subnets.Add(new IPSubnet(new IPAddress(b), prefix));
            }

            return subnets.ToArray();
        }

        public IPSubnet(IPAddress ip, int prefix)
        {
            this.IPAddress = ip;
            this.NetworkPrefix = prefix;
        }

        private static byte ReverseBits(byte b)
        {
            // https://graphics.stanford.edu/~seander/bithacks.html#ReverseByteWith32Bits
            return (byte)(((b * 0x0802u & 0x22110u) | (b * 0x8020u & 0x88440u)) * 0x10101u >> 16);
        }

        private static byte[] ReverseBytes(byte[] b)
        {
            byte[] r = new byte[b.Length];

            int i = 0;
            int j = b.Length - 1;

            for (; i < j; i++, j--)
            {
                r[i] = b[j];
                r[j] = b[i];
            }

            return r;
        }

        private static byte[] GetMask(int prefix, int length)
        {
            byte[] mask = (BigInteger.Pow(2, prefix) - 1).ToByteArray();

            int i = mask.Length - 1;
            mask[i] = IPSubnet.ReverseBits(mask[i]);

            Array.Resize(ref mask, length);

            return mask;
        }

        private static byte[] GetStart(byte[] address, byte[] mask)
        {
            byte[] start = new byte[mask.Length];

            for (int i = 0; i < start.Length; i++)
            {
                start[i] = (byte)(address[i] & mask[i]);
            }

            return start;
        }

        private static byte[] GetEnd(byte[] start, byte[] mask)
        {
            byte[] end = new byte[mask.Length];

            for (int i = 0; i < end.Length; i++)
            {
                end[i] = (byte)(start[i] | (~mask[i] & byte.MaxValue));
            }

            return end;
        }
    }
}
