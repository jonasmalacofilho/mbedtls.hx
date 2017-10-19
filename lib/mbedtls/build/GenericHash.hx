package mbedtls.build;

#if !macro
@:autoBuild(mbedtls.build.GenericHash.build())
interface GenericHash {}
#else

import haxe.macro.Context;
using haxe.macro.TypeTools;

class GenericHash {
	public static function build()
	{
		var cl = Context.getLocalClass().get();
		var variant = cl.name.toLowerCase();
		var t = Context.getLocalType().toComplexType();
		var TCtx = macro : mbedtls.build.HashContext<$t>;
		var tmp = macro class {

			static var _make:haxe.io.BytesData->haxe.io.BytesData = neko.Lib.load("mbedtls", $v{variant+"_make"}, 1);
			static var _init:Void->$TCtx = neko.Lib.load("mbedtls", $v{variant+"_init"}, 0);
			static var _update:$TCtx->haxe.io.BytesData->Int->Int->Void = neko.Lib.load("mbedtls", $v{variant+"_update"}, 4);
			static var _finish:$TCtx->haxe.io.BytesData = neko.Lib.load("mbedtls", $v{variant+"_finish"}, 1);
			static var _self_test:Bool->Int = neko.Lib.load("mbedtls", $v{variant+"_self_test"}, 1);

			var ctx:$TCtx;

			/**
			Initialize and setup the hash function context
			**/
			public function new()
				ctx = _init();

			/**
			Process data from buffer

			@param  bytes  Buffer with the data to process
			@param  pos    Starting position to read from `bytes`
			@param  len    Total length to read from `bytes`
			**/
			public function update(bytes:haxe.io.Bytes, pos:Int, len:Int)
			{
				if (ctx == null)
					throw "Can't call `update()` after `finish()`";
				_update(ctx, bytes.getData(), pos, len);
			}

			/**
			Compute the final digest

			The context is cleared and no other methods can called after calling `finish()`.

			@returns The resulting digest
			**/
			public function finish()
			{
				var o = _finish(ctx);
				ctx = null;
				return haxe.io.Bytes.ofData(o);
			}

			/**
			Compute the hexadecimal digest of `string`

			This method exists for convenience and to mirror the equivalent
			`haxe.crypto.*` API.  However, it is not suited for large inputs.

			@param  string  Entire data to be processed
			@returns        A string containing the hexadecimal representation of the digest
			**/
			public static function encode(string:String):String
				return haxe.io.Bytes.ofData(_make(haxe.io.BytesData.ofString(string))).toHex();

			/**
			Compute the digest of `bytes`

			This method exists for convenience and to mirror the equivalent
			`haxe.crypto.*` API.  However, it is not suited for large inputs.

			@param  bytes  Entire data to be processed
			@returns       The resulting digest
			**/
			public static function make(bytes:haxe.io.Bytes):haxe.io.Bytes
				return haxe.io.Bytes.ofData(_make(bytes.getData()));

		}
		return Context.getBuildFields().concat(tmp.fields);
	}
}

#end
