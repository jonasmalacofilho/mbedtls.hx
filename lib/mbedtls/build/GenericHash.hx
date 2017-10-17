package mbedtls.build;

#if !macro
@:autoBuild(mbedtls.build.GenericHash.build())
class GenericHash {}
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
			static var _update:$TCtx->haxe.io.BytesData->Int->Void = neko.Lib.load("mbedtls", $v{variant+"_update"}, 3);
			static var _finish:$TCtx->haxe.io.BytesData = neko.Lib.load("mbedtls", $v{variant+"_finish"}, 1);

			var ctx:$TCtx;

			public function new()
				ctx = _init();

			public function update(b:haxe.io.Bytes, len:Int)
			{
				if (ctx == null)
					throw "Can't call `update()` after `finish()`";
				_update(ctx, b.getData(), len);
			}

			public function finish()
			{
				var o = _finish(ctx);
				ctx = null;
				return haxe.io.Bytes.ofData(o);
			}

			public static function encode(s:String):String
				return haxe.io.Bytes.ofData(_make(haxe.io.BytesData.ofString(s))).toHex();
			public static function make(b:haxe.io.Bytes):haxe.io.Bytes
				return haxe.io.Bytes.ofData(_make(b.getData()));

		}
		return Context.getBuildFields().concat(tmp.fields);
	}
}
#end

