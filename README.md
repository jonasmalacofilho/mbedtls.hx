# mbedtls.hx
_Partial/future CFFI for Haxe/Neko to the awesome mbed TLS_  
_(or, for now, fast hash functions for Haxe/Neko)_

## Usage

When possible, the Haxe APIs follow their existing `haxe.crypto.*` counterparts, so that the library can be a simple to adopt performance upgrade.

Additionally, lower-level and even more efficient APIs are provided as well.

For more information, check the [complete API documentation](https://jonasmalaco.com/mbedtls.hx).

```haxe
// Test.hx
class Test {
  static function main()
  {
    // use the haxe.crypto.* style APIs for convenience
    var fox = "The quick brown fox jumps over the lazy dog";
    trace(mbedtls.Sha512.encode(fox));

    // or the streaming APIs to be able to process large ammounts of data
    var buf = haxe.io.Bytes.alloc(1 << 20);                             // 1 MiB
    buf.fill(0, buf.length, "x".code);
    var hash = new mbedtls.Sha512();
    for (i in 0...1024)                           // total data processed: 1 GiB
      hash.update(buf, 0, buf.length);
    trace(hash.finish().toHex());
  }
}
```

```
# test.hxml
-lib mbedtls
-main Test
-neko test.n
```

## Status

Work is ongoing...

CFFI coverage:

 - [x] crypto hash functions: SHA2 family (SHA224, SHA256, SHA384, SHA512)
 - [x] other/older hash functions: MD5, SHA1
 - [x] streaming hash APIs to process data in chunks
 - [ ] and more

Build/package coverage:

 - [x] Linux x86/x86-64
 - [ ] Windows (under development/help wanted)
 - [ ] Mac (help wanted)
 - [ ] iOS ARM (help wanted)
 - [ ] Linux ARM

Target coverage:

 - [x] Neko
 - [ ] C++/Hxcpp (help wanted)

Other:

 - [x] Documentation

## Original motivation

The original purpose of starting this library was to provide a very substantial performance boost for modules running on Tora that compute a lot of hashes, either for password hashing, file deduplication/identification or other use cases.

Even with interpreter and CFFI overhead, performance is now much closer to the `<hash>sum` utilities from coreutils, both in cpu time and memory consumption.

![screenshot from 2017-10-11 15-55-07](https://user-images.githubusercontent.com/1832496/31460372-9460fc70-ae9c-11e7-98be-41072edd427a.png)

