const std = @import("std");

pub fn build(b: *std.Build) void {
    const aim = b.standardTargetOptions(.{});
    const opt = b.standardOptimizeOption(.{});

    const lib = b.addModule("STDIOReaderWriter", .{
        .root_source_file = b.path("./STDIOReaderWriter.zig"),
        .target = aim,
        .optimize = opt,
    });
    const string = b.dependency("string", .{
        .target = aim,
        .optimize = opt,
    });
    lib.addImport("string", string.module("string"));

    const tests_mod = b.addModule("STDIOReaderWriter", .{
        .root_source_file = b.path("test.zig"),

        .target = aim,
        .optimize = opt,
    });
    tests_mod.addImport("STDIOReaderWriter", lib);
    const tests = b.addTest(.{
        .root_module = tests_mod,
    });

    const tests_run = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run all library tests");
    test_step.dependOn(&tests_run.step);
}
