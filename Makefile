TEST_ARGS = -fPIC -target x86-linux -L./lib -lstub ./src/ff.zig

.PHONY: all
all: test

.PHONY: test
test:
	zig test $(TEST_ARGS)

.PHONY: spy
spy:
	spy --exc .zig-cache --inc "**/*.zig" -q clear-zig test $(TEST_ARGS)

.PHONY: docs
docs:
	zig build-lib -fno-emit-bin -femit-docs src/ff.zig
