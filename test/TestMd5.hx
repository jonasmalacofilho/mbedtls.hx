import utest.Assert;

import haxe.io.Bytes;
import mbedtls.Md5;

class TestMd5 {
	public function new() {}

	public function testLikeHaxe()
	{
		Assert.equals("d41d8cd98f00b204e9800998ecf8427e",
				Md5.encode(""));
		Assert.equals("9e107d9d372bb6826bd81d3542a419d6",
				Md5.encode("The quick brown fox jumps over the lazy dog"));
	}

	public function testStreaming()
	{
		var text = "The quick brown fox jumps over the lazy dog";
		var digest = new Md5();
		digest.update(Bytes.ofString(text), 17);
		for (c in text.substr(17).split(""))
			digest.update(Bytes.ofString(c), 1);
		digest.update(Bytes.ofString(""), 0);
		Assert.equals(Md5.encode(text), digest.finish().toHex());
	}
}

