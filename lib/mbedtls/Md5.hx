package mbedtls;

import haxe.io.BytesData;
import haxe.io.Bytes;

/*
MD5 Message Digest Algorithm
*/
class Md5 {
	static var _make(get,null):BytesData->BytesData;
		static inline function get__make()
		{
			if (_make == null)
				_make = neko.Lib.load("mbedtls", "md5_make", 1);
			return _make;
		}

	public static function encode(s:String):String
		return Bytes.ofData(_make(BytesData.ofString(s))).toHex();

	public static function make(b:Bytes):Bytes
		return Bytes.ofData(_make(b.getData()));
}
