package mbedtls;

/**
SHA-1 Cryptographic Hash Function

Warning: SHA-1 is not considered secure anymore, for most applications.
Consider using SHA-256 or SHA-512 instead (or their truncated variantes,
SHA-224 or SHA-384).
**/
class Sha1 implements mbedtls.build.GenericHash {}

