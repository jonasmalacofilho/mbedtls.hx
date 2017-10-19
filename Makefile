LIB_NAME=mbedtls
CFLAGS=-fPIC
LDFLAGS=-lmbedtls

default: set-dev unit-test ALWAYS

unit-test: test.n ALWAYS
	neko test.n

test.n: ALWAYS
	haxe test.hxml

#
# documentation
#

docs: ALWAYS
	haxe -cp lib --macro "include('mbedtls')" -xml doc.xml -D doc-gen -neko noop --no-output
	haxelib run dox -i doc.xml -o docs --toplevel-package mbedtls --exclude mbedtls.build \
		--title 'mbedtls.hx / Haxe / API docs' \
		-D themeColor 0x62BE5E \
		-D source-path https://github.com/jonasmalacofilho/$(LIB_NAME).hx/tree/master/lib/
	sed -i -e 's/expando/expand/' docs/nav.js
	find docs -iname '*.html' -exec sed -i -e 's/top level/mbedtls root/' {} \;

#
# development settings
#

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

#
# ndlls
#

# linux
ndll/L%/$(LIB_NAME).ndll: src/$(LIB_NAME).c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $^ -shared $(LDFLAGS) -o $@

#
# packaging
#

# make a package with whatever ndlls have been built
package: set-pkg unit-test ALWAYS

$(LIB_NAME).zip: docs ALWAYS
	rm -f $@
	zip -r $@ ./* -x '*.zip' -x '**/.*' -x '*.n'

#
# cleaning
#

clean: ALWAYS
	rm -rf ndll docs
	rm -f doc.xml test.n

dist-clean: clean ALWAYS
	rm -f './$(LIB_NAME).zip'  # leave renamed packages behind

#
# cross compiling
#

dockcross-all: dockcross-linux-x64 dockcross-linux-x86 ALWAYS

dockcross-linux-x%: ALWAYS
	extra/$@ bash -c 'make __jessie-linux-x$*'

#
# DANGER ZONE
#

# linux builds on debian jessie (used by dockcross)
__jessie-linux-x%: ALWAYS
	ls -l /.dockerenv  # make sure we're inside a container
	echo 'deb http://ftp.debian.org/debian jessie-backports main' | sudo tee /etc/apt/sources.list.d/jessie-backports.list >/dev/null
	sudo apt-get -y update >/dev/null
	sudo apt-get -y install -t jessie-backports neko-dev libmbedtls-dev:$(subst 86,i386,$(findstring 86,$*)) >/dev/null
	make ndll/Linux$(subst 86,,$*)/$(LIB_NAME).ndll

.PHONY: ALWAYS

