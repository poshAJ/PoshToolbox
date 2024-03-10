// Copyright (c) 2023 Anthony J. Raymond, MIT License (see manifest for details)

using System;

namespace PoshToolbox
{
    public class LimitException : Exception
    {
        public LimitException(string Message) : base(Message) { }
    }
}
