package mbedtls;

import haxe.io.BytesData;
import haxe.io.Bytes;

private abstract Md5Context(Dynamic) {}

/*
MD5 Message Digest Algorithm
*/
class Md5 {
	static var _make:BytesData->BytesData = neko.Lib.load("mbedtls", "md5_make", 1);
	static var _init:Void->Md5Context = neko.Lib.load("mbedtls", "md5_init", 0);
	static var _update:Md5Context->BytesData->Int->Void = neko.Lib.load("mbedtls", "md5_update", 3);
	static var _finish:Md5Context->BytesData = neko.Lib.load("mbedtls", "md5_finish", 1);

	var ctx:Md5Context;

	public function new()
	{
		ctx = _init();
	}

	public function update(b:Bytes, len:Int)
	{
		if (ctx == null)
			throw "Can't call `update()` after `finish()`";
		_update(ctx, b.getData(), len);
	}

	public function finish()
	{
		var o = _finish(ctx);
		ctx = null;
		return Bytes.ofData(o);
	}

	public static function encode(s:String):String
		return Bytes.ofData(_make(BytesData.ofString(s))).toHex();

	public static function make(b:Bytes):Bytes
		return Bytes.ofData(_make(b.getData()));
}
