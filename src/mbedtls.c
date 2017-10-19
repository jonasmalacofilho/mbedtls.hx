#include <neko.h>
#include "mbedtls/md5.h"
#include "mbedtls/sha1.h"
#include "mbedtls/sha256.h"
#include "mbedtls/sha512.h"

#define VARIANT_ARG__md5
#define VARIANT_ARG__sha1
#define VARIANT_ARG__sha224   , true
#define VARIANT_ARG__sha256   , false
#define VARIANT_ARG__sha384   , true
#define VARIANT_ARG__sha512   , false
#define VARIANT_ARG(VARIANT)  VARIANT_ARG__##VARIANT

#define CFFI_HASH_INIT(VARIANT, HASH) \
	static value VARIANT##_init() \
	{ \
		mbedtls_##HASH##_context *ctx; \
		ctx = (mbedtls_##HASH##_context *)alloc(sizeof(mbedtls_##HASH##_context)); \
		mbedtls_##HASH##_init(ctx); \
		mbedtls_##HASH##_starts(ctx VARIANT_ARG(VARIANT)); \
		return alloc_abstract(k_##VARIANT, ctx); \
	} \
	DEFINE_PRIM(VARIANT##_init, 0);

#define CFFI_HASH_UPDATE(VARIANT, HASH) \
	static value VARIANT##_update(value ctx, value s, value pos, value len) \
	{ \
		val_check_kind(ctx, k_##VARIANT); \
		val_check(s, string); \
		val_check(pos, int); \
		val_check(len, int); \
		if (val_int(pos) < 0 || val_int(pos) > val_strlen(s)) \
			val_throw(alloc_string("Outside bounds: pos")); \
		if (val_int(len) < 0 || val_int(len) > val_strlen(s) - val_int(pos)) \
			val_throw(alloc_string("Outside bounds: len")); \
		mbedtls_##HASH##_update(val_data(ctx), val_string(s) + val_int(pos), val_int(len)); \
		return val_null; \
	} \
	DEFINE_PRIM(VARIANT##_update, 4);

#define CFFI_HASH_FINISH(VARIANT, HASH, OUTPUTSIZE) \
	static value VARIANT##_finish(value ctx) \
	{ \
		value out; \
		val_check_kind(ctx, k_##VARIANT); \
		out = alloc_empty_string(OUTPUTSIZE); \
		mbedtls_##HASH##_finish(val_data(ctx), val_string(out)); \
		val_kind(ctx) = NULL; \
		return out; \
	} \
	DEFINE_PRIM(VARIANT##_finish, 1);

#define CFFI_HASH_MAKE(VARIANT, HASH, OUTPUTSIZE) \
	static value VARIANT##_make(value s) \
	{ \
		value out; \
		val_check(s, string); \
		out = alloc_empty_string(OUTPUTSIZE); \
		mbedtls_##HASH(val_string(s), val_strlen(s), val_string(out) VARIANT_ARG(VARIANT)); \
		return out; \
	} \
	DEFINE_PRIM(VARIANT##_make, 1); \

#define CFFI_HASH_BUILD(VARIANT, HASH, OUTPUTSIZE) \
	DEFINE_KIND(k_##VARIANT); \
	CFFI_HASH_INIT(VARIANT, HASH); \
	CFFI_HASH_UPDATE(VARIANT, HASH); \
	CFFI_HASH_FINISH(VARIANT, HASH, OUTPUTSIZE); \
	CFFI_HASH_MAKE(VARIANT, HASH, OUTPUTSIZE);

CFFI_HASH_BUILD(md5, md5, 16);
CFFI_HASH_BUILD(sha1, sha1, 20);
CFFI_HASH_BUILD(sha224, sha256, 28);
CFFI_HASH_BUILD(sha256, sha256, 32);
CFFI_HASH_BUILD(sha384, sha512, 48);
CFFI_HASH_BUILD(sha512, sha512, 64);

