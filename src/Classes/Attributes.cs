// Copyright (c) 2024 Anthony J. Raymond, MIT License (see manifest for details)

using System;
using System.Text;
using System.Linq;
using System.Globalization;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Management.Automation;

namespace PoshToolbox
{
    // Copyright (c) Microsoft Corporation, https://github.com/PowerShell/PowerShell, MIT License
    // Modified "src/System.Management.Automation/utils/PathUtils.cs" by Anthony J. Raymond
    internal static class PathUtils
    {
        internal static string[] ResolveFilePath(string filePath, SessionState sessionState, bool isLiteralPath)
        {
            string[] paths = new[] { filePath };

            if (!isLiteralPath)
            {
                try
                {
                    paths = sessionState.Path.GetResolvedPSPathFromPSPath(filePath)
                        .Select(pathInfo => pathInfo.Path)
                        .ToArray();
                }
                catch (ItemNotFoundException e)
                {
                    paths = new[] { e.ItemName };
                }
            }

            List<string> result = new List<string>();

            foreach (string path in paths)
            {
                result.Add(sessionState.Path.GetUnresolvedProviderPathFromPSPath(path, out ProviderInfo provider, out PSDriveInfo drive));

                if (provider.ImplementingType.FullName != "Microsoft.PowerShell.Commands.FileSystemProvider")
                {
                    throw new PSArgumentException("The argument specified must resolve to a valid path on the FileSystem provider.");
                }
            }

            return result.ToArray();
        }
    }

    public sealed class FileSystemPathTransformation : ArgumentTransformationAttribute
    {
        public override object Transform(EngineIntrinsics engineIntrinsics, object inputData)
        {
            SessionState sessionState = new SessionState();

            switch (inputData)
            {
                case string value:
                    return PathUtils.ResolveFilePath(value, sessionState, false);

                case IList<object> values:
                    List<string> filePaths = new List<string>();

                    for (int i = 0; i < values.Count; i++)
                    {
                        string value = values[i] as string;

                        filePaths.AddRange(PathUtils.ResolveFilePath(value, sessionState, false));
                    }

                    return filePaths.ToArray();
            }

            return inputData;
        }
    }

    public sealed class FileSystemLiteralPathTransformation : ArgumentTransformationAttribute
    {
        public override object Transform(EngineIntrinsics engineIntrinsics, object inputData)
        {
            SessionState sessionState = new SessionState();

            switch (inputData)
            {
                case string value:
                    return PathUtils.ResolveFilePath(value, sessionState, true);

                case IList<object> values:
                    List<string> filePaths = new List<string>();

                    for (int i = 0; i < values.Count; i++)
                    {
                        string value = values[i] as string;

                        filePaths.AddRange(PathUtils.ResolveFilePath(value, sessionState, true));
                    }

                    return filePaths.ToArray();
            }

            return inputData;
        }
    }

    public sealed class ReturnFirstOrInputTransformation : ArgumentTransformationAttribute
    {
        public override object Transform(EngineIntrinsics engineIntrinsics, object inputData)
        {
            if (inputData is IList<object> values)
            {
                return values[0];
            }

            return inputData;
        }
    }

    // Copyright (c) Microsoft Corporation, https://github.com/PowerShell/PowerShell, MIT License
    // Modified "src/System.Management.Automation/utils/EncodingUtils.cs" by Anthony J. Raymond
    public sealed class EncodingTransformation : ArgumentTransformationAttribute
    {
        internal static readonly Dictionary<string, Encoding> encodingMap = new Dictionary<string, Encoding>(StringComparer.OrdinalIgnoreCase)
        {
            { "ansi", Encoding.GetEncoding(CultureInfo.CurrentCulture.TextInfo.ANSICodePage) },
            { "ascii", Encoding.ASCII },
            { "bigendianunicode", Encoding.BigEndianUnicode },
            { "bigendianutf32", new UTF32Encoding(bigEndian: true, byteOrderMark: true) },
            { "default", Encoding.Default },
            { "oem", Encoding.Default },
            { "string", Encoding.Unicode },
            { "unicode", Encoding.Unicode },
            { "unknown", Encoding.Unicode },
            { "utf7", Encoding.UTF7 },
            { "utf8", Encoding.Default },
            { "utf8BOM", Encoding.UTF8 },
            { "utf8NoBOM", Encoding.Default },
            { "utf32", Encoding.UTF32 },
        };

        public override object Transform(EngineIntrinsics engineIntrinsics, object inputData)
        {
            switch (inputData)
            {
                case string value:
                    if (encodingMap.TryGetValue(value, out Encoding encoding))
                    {
                        return encoding;
                    }
                    else
                    {
                        return Encoding.GetEncoding(value);
                    }
                case int value:
                    return Encoding.GetEncoding(value);
            }

            return inputData;
        }
    }
}
