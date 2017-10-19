import utest.Assert;

class TestExample {
	public function new() {}

	public function testExample()
	{
		// use the haxe.crypto.* style APIs for convenience
		var fox = "The quick brown fox jumps over the lazy dog";
		trace(mbedtls.Sha512.encode(fox));

		// or the streaming APIs to be able to process large ammounts of data
		var buf = haxe.io.Bytes.alloc(1 << 20);  // 1 MiB
		buf.fill(0, buf.length, "x".code);
		var hash = new mbedtls.Sha512();
		for (i in 0...1000)  // total data processed: 1 GiB
			hash.update(buf, 0, buf.length);
		trace(hash.finish().toHex());

		Assert.pass();
	}
}
