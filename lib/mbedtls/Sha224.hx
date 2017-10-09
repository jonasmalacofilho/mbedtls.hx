package mbedtls;

import haxe.io.BytesData;
import haxe.io.Bytes;

/*
SHA-224 Cryptographic Hash Function
*/
class Sha224 {
	public static function encode(s:String):String
		return Bytes.ofData(Sha256._make(BytesData.ofString(s), true)).sub(0, 28).toHex();

	public static function make(b:Bytes):Bytes
		return Bytes.ofData(Sha256._make(b.getData(), true)).sub(0, 28);
}
