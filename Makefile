unit-test: ndll/Linux64/sha256.ndll test.n _PHONY
	neko test.n

test.n: _PHONY
	haxe test.hxml

ndll/Linux64/sha256.ndll: src/sha256.c
	$(CC) $(CFLAGS) src/sha256.c -shared -o ndll/Linux64/sha256.ndll -fPIC -lmbedtls

clean: _PHONY
	rm ndll/*/sha256.ndll

.PHONY: _PHONY

