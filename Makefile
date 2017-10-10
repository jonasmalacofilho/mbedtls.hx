LIB_NAME=mbedtls
CFLAGS=-fPIC
LDFLAGS=-lmbedtls

all: ndll/Linux64/$(LIB_NAME).ndll set-dev test.n ALWAYS

unit-test: test.n ALWAYS
	neko test.n

test.n: ALWAYS
	haxe test.hxml

ndll/Linux/$(LIB_NAME).ndll: src/$(LIB_NAME).c
	mkdir -p ndll/Linux
	$(CC) $(CFLAGS) -m32 $^ -shared $(LDFLAGS) -o $@

ndll/Linux64/$(LIB_NAME).ndll: src/$(LIB_NAME).c
	mkdir -p ndll/Linux64
	$(CC) $(CFLAGS) -m64 $^ -shared $(LDFLAGS) -o $@

$(LIB_NAME).zip: all
	rm -f $@
	zip -r $@ ./* -x '*.zip' -x '**/.*' -x '*.n'

set-pkg: $(LIB_NAME).zip
	haxelib remove $(LIB_NAME)
	haxelib install $(LIB_NAME).zip
	haxelib path $(LIB_NAME)

set-dev: ALWAYS
	haxelib dev $(LIB_NAME) $(PWD)
	haxelib path $(LIB_NAME)

set-live: ALWAYS
	haxelib remove $(LIB_NAME)
	haxelib install $(LIB_NAME)
	haxelib path $(LIB_NAME)

prepare-dist: set-pkg unit-test ALWAYS

clean: ALWAYS
	rm -rf ndll

dist-clean: clean ALWAYS
	rm -f *.zip

.PHONY: ALWAYS

