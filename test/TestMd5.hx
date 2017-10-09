import utest.Assert;

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
}

