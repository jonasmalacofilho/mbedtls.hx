import utest.Assert;

import haxe.io.Bytes;
import mbedtls.Sha1;

class TestSha1 {
	public function new() {}

	public function testLikeHaxe()
	{
		Assert.equals("da39a3ee5e6b4b0d3255bfef95601890afd80709",
				Sha1.encode(""));
		Assert.equals("2fd4e1c67a2d28fced849ee1bb76e7391b93eb12",
				Sha1.encode("The quick brown fox jumps over the lazy dog"));
	}

	public function testStreaming()
	{
		var text = "The quick brown fox jumps over the lazy dog";
		var bytes = Bytes.ofString(text);
		var digest = new Sha1();
		digest.update(bytes, 0, 17);
		for (i in 17...text.length)
			digest.update(bytes, i, 1);
		digest.update(Bytes.ofString(""), 0, 0);
		Assert.equals(Sha1.encode(text), digest.finish().toHex());
	}
}

