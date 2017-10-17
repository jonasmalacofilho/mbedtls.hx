import utest.Assert;

import haxe.io.Bytes;
import mbedtls.Sha384;

class TestSha384 {
	public function new() {}

	// https://www.di-mgt.com.au/sha_testvectors.html
	public function testMoreVectors()
	{
		Assert.equals("cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7",
				Sha384.encode("abc"));
		Assert.equals("38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b",
				Sha384.encode(""));
		Assert.equals("3391fdddfc8dc7393707a65b1b4709397cf8b1d162af05abfe8f450de5f36bc6b0455a8520bc4e6f5fe95b1fe3c8452b",
				Sha384.encode("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"));
		Assert.equals("09330c33f71147e83d192fc782cd1b4753111b173b3b05d22fa08086e3b0f712fcc7c71a557e2db966c3e9fa91746039",
				Sha384.encode("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"));
		var millionAs = haxe.io.Bytes.alloc(1000000);
		millionAs.fill(0, 1000000, "a".code);
		Assert.equals("9d0e1809716474cb086e834e310a4a1ced149e9c00f248527972cec5704c2a5b07b8b3dc38ecc4ebae97ddd87f3d8985",
				Sha384.encode(millionAs.toString()));
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
		Assert.equals("38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b",
				Sha384.make(zeros(0)).toHex());
		Assert.equals("bec021b4f368e3069134e012c2b4307083d3a9bdd206e24e5f0d86e13d6636655933ec2b413465966817a9c208a11717",
				Sha384.make(zeros(1)).toHex());
		Assert.equals("1dd6f7b457ad880d840d41c961283bab688e94e4b59359ea45686581e90feccea3c624b1226113f824f315eb60ae0a7c",
				Sha384.make(zeros(2)).toHex());
	}

	public function testStreaming()
	{
		var text = "The quick brown fox jumps over the lazy dog";
		var digest = new Sha384();
		digest.update(Bytes.ofString(text), 17);
		for (c in text.substr(17).split(""))
			digest.update(Bytes.ofString(c), 1);
		digest.update(Bytes.ofString(""), 0);
		Assert.equals(Sha384.encode(text), digest.finish().toHex());
	}
}

