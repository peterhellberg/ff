const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("ff", .{
        .root_source_file = b.path("src/ff.zig"),
    });
}
