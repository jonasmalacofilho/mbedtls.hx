package mbedtls;

import haxe.io.BytesData;
import haxe.io.Bytes;

/**
    Creates a Sha256 of a String.
*/
class Sha256 {
	static var sha256_make:BytesData->BytesData = neko.Lib.load("sha256", "sha256_make", 1);

	public static function encode(s:String):String
		return Bytes.ofData(sha256_make(BytesData.ofString(s))).toHex();

	public static function make(b:Bytes):Bytes
		return Bytes.ofData(sha256_make(b.getData()));
}
