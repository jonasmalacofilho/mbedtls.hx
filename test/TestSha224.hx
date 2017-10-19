import utest.Assert;

import haxe.io.Bytes;
import mbedtls.Sha224;

class TestSha224 {
	public function new() {}

	public function testLikeHaxe()
	{
		Assert.equals("d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f",
				Sha224.encode(""));
		Assert.equals("730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525",
				Sha224.encode("The quick brown fox jumps over the lazy dog"));
	}

	// https://www.di-mgt.com.au/sha_testvectors.html
	public function testMoreVectors()
	{
		Assert.equals("23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7",
				Sha224.encode("abc"));
		Assert.equals("75388b16512776cc5dba5da1fd890150b0c6455cb4f58b1952522525",
				Sha224.encode("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"));
		Assert.equals("c97ca9a559850ce97a04a96def6d99a9e0e0e2ab14e6b8df265fc0b3",
				Sha224.encode("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"));
		var millionAs = haxe.io.Bytes.alloc(1000000);
		millionAs.fill(0, 1000000, "a".code);
		Assert.equals("20794655980c91d8bbb4c1ea97618a4bf03f42581948b2ee4ee7ad67",
				Sha224.encode(millionAs.toString()));
	}

	// https://www.cosic.esat.kuleuven.be/nessie/testvectors/hash/sha/
	public function testZeroBytes()
	{
		function zeros(n:Int) {
			var b = haxe.io.Bytes.alloc(n);
			for (i in 0...n)
				b.set(i, 0);
			return b;
		}
		Assert.equals("d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f",
				Sha224.make(zeros(0)).toHex());
	}

	public function testStreaming()
	{
		var text = "The quick brown fox jumps over the lazy dog";
		var bytes = Bytes.ofString(text);
		var digest = new Sha224();
		digest.update(bytes, 0, 17);
		for (i in 17...text.length)
			digest.update(bytes, i, 1);
		digest.update(Bytes.ofString(""), 0, 0);
		Assert.equals(Sha224.encode(text), digest.finish().toHex());
	}

	public function testSelf()
	{
		Assert.equals(0, @:privateAccess Sha224._self_test(false));
	}
}

