package mbedtls;

import haxe.io.BytesData;
import haxe.io.Bytes;

/**
    Creates a Sha384 of a String.
*/
class Sha384 {
	public static function encode(s:String):String
		return Bytes.ofData(Sha512._make(BytesData.ofString(s), true)).sub(0, 48).toHex();

	public static function make(b:Bytes):Bytes
		return Bytes.ofData(Sha512._make(b.getData(), true)).sub(0, 48);
}
