// Copyright (c) 2024 Anthony J. Raymond, MIT License (see manifest for details)

using System;
using System.Net;
using System.Management.Automation;

namespace PoshToolbox
{
    public sealed class FindNlMtuCommand
    {
        public sealed class NlMtuInfo
        {
            public readonly string ComputerName;
            public readonly IPAddress ReplyFrom;
            public readonly long RoundtripTime;
            public readonly int Hops;
            public readonly int NlMtu;

            public NlMtuInfo(string computerName, IPAddress replyFrom, long roundtripTime, int hops, int nlMtu)
            {
                ComputerName = computerName;
                ReplyFrom = replyFrom;
                RoundtripTime = roundtripTime;
                Hops = hops;
                NlMtu = nlMtu;
            }
        }
    }

    public sealed class GetFolderPropertiesCommand
    {
        public sealed class FolderPropertiesInfo
        {
            public readonly string FullName;
            public readonly long Length;
            public readonly string Size;
            public readonly string Contains;
            public readonly DateTime Created;

            public FolderPropertiesInfo(string fullName, long length, string size, string contains, DateTime created)
            {
                FullName = fullName;
                Length = length;
                Size = size;
                Contains = contains;
                Created = created;
            }
        }
    }

    public sealed class ResolvePoshPathCommand
    {
        public sealed class PoshPathInfo
        {
            public readonly string Path;
            public readonly string ProviderPath;
            public readonly ProviderInfo Provider;
            public readonly PSDriveInfo Drive;

            public PoshPathInfo(string path, string providerPath, ProviderInfo provider, PSDriveInfo drive)
            {
                Path = path;
                ProviderPath = providerPath;
                Provider = provider;
                Drive = drive;
            }
        }
    }
}
