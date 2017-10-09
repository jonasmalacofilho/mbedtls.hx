#include <neko.h>
#include "mbedtls/sha256.h"
#include "mbedtls/sha512.h"

value sha256_make(value s, value trunc)
{
	val_check(s, string);
	val_check(trunc, bool);
	value out = alloc_empty_string(32);
	mbedtls_sha256(val_string(s), val_strlen(s), val_string(out), val_bool(trunc));
	return out;
}

DEFINE_PRIM(sha256_make, 2);

value sha512_make(value s, value trunc)
{
	val_check(s, string);
	val_check(trunc, bool);
	value out = alloc_empty_string(64);
	mbedtls_sha512(val_string(s), val_strlen(s), val_string(out), val_bool(trunc));
	return out;
}

DEFINE_PRIM(sha512_make, 2);

