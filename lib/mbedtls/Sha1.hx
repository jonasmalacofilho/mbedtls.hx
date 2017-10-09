package mbedtls;

import haxe.io.BytesData;
import haxe.io.Bytes;

/*
SHA-1 Cryptographic Hash Function
*/
class Sha1 {
	static var _make:BytesData->BytesData = neko.Lib.load("mbedtls", "sha1_make", 1);

	public static function encode(s:String):String
		return Bytes.ofData(_make(BytesData.ofString(s))).toHex();

	public static function make(b:Bytes):Bytes
		return Bytes.ofData(_make(b.getData()));
}
