class ExponentialBackoffLimitException : Exception {
    ExponentialBackoffLimitException ([string] $Message) : base($Message) {}
}
