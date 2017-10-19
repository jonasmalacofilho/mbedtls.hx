import utest.Assert;

import haxe.io.Bytes;
import mbedtls.Sha512;

class TestSha512 {
	public function new() {}

	// https://www.di-mgt.com.au/sha_testvectors.html
	public function testMoreVectors()
	{
		Assert.equals("ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f",
				Sha512.encode("abc"));
		Assert.equals("cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e",
				Sha512.encode(""));
		Assert.equals("204a8fc6dda82f0a0ced7beb8e08a41657c16ef468b228a8279be331a703c33596fd15c13b1b07f9aa1d3bea57789ca031ad85c7a71dd70354ec631238ca3445",
				Sha512.encode("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"));
		Assert.equals("8e959b75dae313da8cf4f72814fc143f8f7779c6eb9f7fa17299aeadb6889018501d289e4900f7e4331b99dec4b5433ac7d329eeb6dd26545e96e55b874be909",
				Sha512.encode("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"));
		var millionAs = haxe.io.Bytes.alloc(1000000);
		millionAs.fill(0, 1000000, "a".code);
		Assert.equals("e718483d0ce769644e2e42c7bc15b4638e1f98b13b2044285632a803afa973ebde0ff244877ea60a4cb0432ce577c31beb009c5c2c49aa2e4eadb217ad8cc09b",
				Sha512.encode(millionAs.toString()));
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
		Assert.equals("cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e",
				Sha512.make(zeros(0)).toHex());
		Assert.equals("b8244d028981d693af7b456af8efa4cad63d282e19ff14942c246e50d9351d22704a802a71c3580b6370de4ceb293c324a8423342557d4e5c38438f0e36910ee",
				Sha512.make(zeros(1)).toHex());
		Assert.equals("5ea71dc6d0b4f57bf39aadd07c208c35f06cd2bac5fde210397f70de11d439c62ec1cdf3183758865fd387fcea0bada2f6c37a4a17851dd1d78fefe6f204ee54",
				Sha512.make(zeros(2)).toHex());
	}

	public function testStreaming()
	{
		var text = "The quick brown fox jumps over the lazy dog";
		var bytes = Bytes.ofString(text);
		var digest = new Sha512();
		digest.update(bytes, 0, 17);
		for (i in 17...text.length)
			digest.update(bytes, i, 1);
		digest.update(Bytes.ofString(""), 0, 0);
		Assert.equals(Sha512.encode(text), digest.finish().toHex());
	}
}

