package mbedtls;

import haxe.io.BytesData;
import haxe.io.Bytes;

private abstract Sha1Context(Dynamic) {}

/*
SHA-1 Cryptographic Hash Function
*/
class Sha1 {
	static var _make:BytesData->BytesData = neko.Lib.load("mbedtls", "sha1_make", 1);
	static var _init:Void->Sha1Context = neko.Lib.load("mbedtls", "sha1_init", 0);
	static var _update:Sha1Context->BytesData->Int->Void = neko.Lib.load("mbedtls", "sha1_update", 3);
	static var _finish:Sha1Context->BytesData = neko.Lib.load("mbedtls", "sha1_finish", 1);

	var ctx:Sha1Context;

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

