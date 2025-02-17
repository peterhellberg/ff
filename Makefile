TEST_ARGS = -fPIC -target x86-linux -L./lib -lstub ./src/root.zig

.PHONY: all
all: test

.PHONY: test
test:
	zig test $(TEST_ARGS)

.PHONY: spy
spy:
	spy --exc .zig-cache --inc "**/*.zig" -q clear-zig test $(TEST_ARGS)
