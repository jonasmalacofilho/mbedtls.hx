import utest.Assert;

import mbedtls.Sha256;

class TestSha256 {
	public function new() {}

	public function testLikeHaxe()
	{
		Assert.equals("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
				Sha256.encode(""));
		Assert.equals("d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592",
				Sha256.encode("The quick brown fox jumps over the lazy dog"));
	}

	public function testMoreVectors()
	{
		Assert.equals("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
				Sha256.encode("abc"));
		Assert.equals("248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1",
				Sha256.encode("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"));
		Assert.equals("cf5b16a778af8380036ce59e7b0492370b249b11e8f07a51afac45037afee9d1",
				Sha256.encode("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"));
		Assert.equals("cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0",
				Sha256.encode([for (i in 0...1000000) "a"].join("")));
	}

	public function testZeroBytes()
	{
		function zeros(n:Int) {
			var b = haxe.io.Bytes.alloc(n);
			for (i in 0...n)
				b.set(i, 0);
			return b;
		}
		Assert.equals("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
				Sha256.make(zeros(0)).toHex());
		Assert.equals("6e340b9cffb37a989ca544e6bb780a2c78901d3fb33738768511a30617afa01d",
				Sha256.make(zeros(1)).toHex());
		Assert.equals("96a296d224f285c67bee93c30f8a309157f0daa35dc5b87e410b78630a09cfc7",
				Sha256.make(zeros(2)).toHex());
	}
}

