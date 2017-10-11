# mbedtls.hx
_Partial/future CFFI for Haxe/Neko to the awesome mbed TLS_
_(or, for now, fast hash functions for Haxe/Neko)_

## Usage

When possible, the Haxe APIs follow existing `std` counterparts, so that the library can be a simple to adopt performance upgrade.

Eventually, more efficient and/or lower-level APIs will be provided as well.

```haxe
// Test.hx
class Test {
    static function main()
    {
        var fox = "The quick brown fox jumps over the lazy dog";
        trace(mbedtls.Sha512.encode(fox));
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

## Original motivation

To give a very substancial performance boost for modules running on Tora and computing a lot of hashes (password hashing, file deduplication/identification, etc.).

Even with CFFI overhead and badly implementated I/O, performance is now much closer to the `<hash>sum` utilities from coreutils.

![screenshot from 2017-10-11 15-55-07](https://user-images.githubusercontent.com/1832496/31460372-9460fc70-ae9c-11e7-98be-41072edd427a.png)

