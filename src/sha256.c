#include <neko.h>
#include "mbedtls/sha256.h"

value sha256_make(value s)
{
	val_check(s, string);
	value out = alloc_empty_string(32);
	mbedtls_sha256(val_string(s), val_strlen(s), val_string(out), 0);
	return out;
}

DEFINE_PRIM(sha256_make, 1);

