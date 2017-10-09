#include <neko.h>
#include "mbedtls/md5.h"
#include "mbedtls/sha1.h"
#include "mbedtls/sha256.h"
#include "mbedtls/sha512.h"

value md5_make(value s)
{
	val_check(s, string);
	value out = alloc_empty_string(16);
	mbedtls_md5(val_string(s), val_strlen(s), val_string(out));
	return out;
}

DEFINE_PRIM(md5_make, 1);

value sha1_make(value s)
{
	val_check(s, string);
	value out = alloc_empty_string(20);
	mbedtls_sha1(val_string(s), val_strlen(s), val_string(out));
	return out;
}

DEFINE_PRIM(sha1_make, 1);

value sha256_make(value s, value is224)
{
	val_check(s, string);
	val_check(is224, bool);
	value out = alloc_empty_string(32);
	mbedtls_sha256(val_string(s), val_strlen(s), val_string(out), val_bool(is224));
	return out;
}

DEFINE_PRIM(sha256_make, 2);

value sha512_make(value s, value is384)
{
	val_check(s, string);
	val_check(is384, bool);
	value out = alloc_empty_string(64);
	mbedtls_sha512(val_string(s), val_strlen(s), val_string(out), val_bool(is384));
	return out;
}

DEFINE_PRIM(sha512_make, 2);

