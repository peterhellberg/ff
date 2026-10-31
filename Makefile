TEST_ARGS = -fPIC -target x86-linux -L./lib -lstub ./src/ff.zig

.PHONY: all
all: test

.PHONY: test
test: lib/libstub.a
	zig test $(TEST_ARGS)

.PHONY: spy
spy: lib/libstub.a
	spy --exc .zig-cache --inc "**/*.zig" -q clear-zig test $(TEST_ARGS)

lib/libstub.a: lib/stub.zig lib/build.sh
	cd lib && ./build.sh

.PHONY: docs
docs:
	zig build-lib -fno-emit-bin -femit-docs src/ff.zig
