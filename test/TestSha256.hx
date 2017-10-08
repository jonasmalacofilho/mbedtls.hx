import utest.Assert;

class TestSha256 {
	public function new() {}

	public function testStd()
	{
		Assert.equals("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", fast.Sha256.encode(""));
		Assert.equals("d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592", fast.Sha256.encode("The quick brown fox jumps over the lazy dog"));
	}
}

