#include <neko.h>
#include "mbedtls/md5.h"
#include "mbedtls/sha1.h"
#include "mbedtls/sha256.h"
#include "mbedtls/sha512.h"

#define CFFI_HASH_MAKE1(HASH, OUTPUTSIZE) \
	static value HASH ## _make(value s) \
	{ \
		val_check(s, string); \
		value out = alloc_empty_string(OUTPUTSIZE); \
		mbedtls_ ## HASH(val_string(s), val_strlen(s), val_string(out)); \
		return out; \
	} \
	DEFINE_PRIM(HASH ## _make, 1); \

#define CFFI_HASH_MAKE2(HASH, OUTPUTSIZE, VARIANT, VARIANTSIZE) \
	static value HASH ## _make(value s, value VARIANT) \
	{ \
		val_check(s, string); \
		value out = alloc_empty_string(val_bool(VARIANT) ? VARIANTSIZE : OUTPUTSIZE); \
		mbedtls_ ## HASH(val_string(s), val_strlen(s), val_string(out), val_bool(VARIANT)); \
		return out; \
	} \
	DEFINE_PRIM(HASH ## _make, 2); \

CFFI_HASH_MAKE1(md5, 16);
CFFI_HASH_MAKE1(sha1, 20);
CFFI_HASH_MAKE2(sha256, 32, is224, 28);
CFFI_HASH_MAKE2(sha512, 64, is384, 48);

