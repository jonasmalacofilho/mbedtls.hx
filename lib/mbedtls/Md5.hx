package mbedtls;

/**
MD5 Message Digest Algorithm

Warning: MD5 is not considered secure anymore. For secure software, please use
SHA-256 or SHA-512 instead (or their truncated variantes, SHA-224 or SHA-384).
**/
class Md5 implements mbedtls.build.GenericHash {}

