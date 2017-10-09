package mbedtls;

import haxe.io.BytesData;
import haxe.io.Bytes;

/**
    Creates a Sha512 of a String.
*/
class Sha512 {
	public static var _make(get,null):BytesData->Bool->BytesData;
		static inline function get__make()
		{
			if (_make == null)
				_make = neko.Lib.load("mbedtls", "sha512_make", 2);
			return _make;
		}

	public static function encode(s:String):String
		return Bytes.ofData(_make(BytesData.ofString(s), false)).toHex();

	public static function make(b:Bytes):Bytes
		return Bytes.ofData(_make(b.getData(), false));
}
