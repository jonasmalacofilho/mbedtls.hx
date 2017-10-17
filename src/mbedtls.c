#include <neko.h>
#include "mbedtls/md5.h"
#include "mbedtls/sha1.h"
#include "mbedtls/sha256.h"
#include "mbedtls/sha512.h"

#define CFFI_HASH_INIT(HASH) \
	DEFINE_KIND(k_ ## HASH); \
	static value HASH ## _init() \
	{ \
		mbedtls_ ## HASH ## _context *ctx; \
		ctx = (mbedtls_ ## HASH ## _context *)alloc(sizeof(mbedtls_ ## HASH ## _context)); \
		mbedtls_ ## HASH ## _init(ctx); \
		mbedtls_ ## HASH ## _starts(ctx); \
		return alloc_abstract(k_ ## HASH, ctx); \
	} \
	DEFINE_PRIM(HASH ## _init, 0);

#define CFFI_HASH_INITv(HASH, VARIANT) \
	DEFINE_KIND(k_ ## HASH); \
	static value HASH ## _init(value VARIANT) \
	{ \
		mbedtls_ ## HASH ## _context *ctx; \
		val_check(VARIANT, bool); \
		ctx = (mbedtls_ ## HASH ## _context *)alloc(sizeof(mbedtls_ ## HASH ## _context)); \
		mbedtls_ ## HASH ## _init(ctx); \
		mbedtls_ ## HASH ## _starts(ctx, val_bool(VARIANT)); \
		return alloc_abstract(k_ ## HASH, ctx); \
	} \
	DEFINE_PRIM(HASH ## _init, 1);

#define CFFI_HASH_UPDATE(HASH) \
	static value HASH ## _update(value ctx, value s, value len) \
	{ \
		val_check_kind(ctx, k_ ## HASH); \
		val_check(s, string); \
		val_check(len, int); \
		mbedtls_ ## HASH ## _update(val_data(ctx), val_string(s), val_int(len)); \
		return val_null; \
	} \
	DEFINE_PRIM(HASH ## _update, 3);

#define CFFI_HASH_FINISH(HASH, OUTPUTSIZE) \
	static value HASH ## _finish(value ctx) \
	{ \
		value out; \
		val_check_kind(ctx, k_ ## HASH); \
		out = alloc_empty_string(OUTPUTSIZE); \
		mbedtls_ ## HASH ## _finish(val_data(ctx), val_string(out)); \
		val_kind(ctx) = NULL; \
		return out; \
	} \
	DEFINE_PRIM(HASH ## _finish, 1);

#define CFFI_HASH_FINISHv(HASH, VARIANT, OUTPUTSIZE, VARIANTSIZE) \
	static value HASH ## _finish(value ctx, value VARIANT) \
	{ \
		value out; \
		val_check_kind(ctx, k_ ## HASH); \
		val_check(VARIANT, bool); \
		out = alloc_empty_string(val_bool(VARIANT) ? VARIANTSIZE : OUTPUTSIZE); \
		mbedtls_ ## HASH ## _finish(val_data(ctx), val_string(out)); \
		val_kind(ctx) = NULL; \
		return out; \
	} \
	DEFINE_PRIM(HASH ## _finish, 2);

#define CFFI_BUILD_HASH(HASH, OUTPUTSIZE) \
	CFFI_HASH_INIT(HASH); \
	CFFI_HASH_UPDATE(HASH); \
	CFFI_HASH_FINISH(HASH, OUTPUTSIZE); \
	static value HASH ## _make(value s) \
	{ \
		value out; \
		val_check(s, string); \
		out = alloc_empty_string(OUTPUTSIZE); \
		mbedtls_ ## HASH(val_string(s), val_strlen(s), val_string(out)); \
		return out; \
	} \
	DEFINE_PRIM(HASH ## _make, 1); \

#define CFFI_BUILD_HASHv(HASH, OUTPUTSIZE, VARIANT, VARIANTSIZE) \
	CFFI_HASH_INITv(HASH, VARIANT); \
	CFFI_HASH_UPDATE(HASH); \
	static value HASH ## _make(value s, value VARIANT) \
	{ \
		value out; \
		val_check(s, string); \
		val_check(VARIANT, bool); \
		out = alloc_empty_string(val_bool(VARIANT) ? VARIANTSIZE : OUTPUTSIZE); \
		mbedtls_ ## HASH(val_string(s), val_strlen(s), val_string(out), val_bool(VARIANT)); \
		return out; \
	} \
	DEFINE_PRIM(HASH ## _make, 2); \

CFFI_BUILD_HASH(md5, 16);
CFFI_BUILD_HASH(sha1, 20);
CFFI_BUILD_HASHv(sha256, 32, is224, 28);
CFFI_BUILD_HASHv(sha512, 64, is384, 48);

