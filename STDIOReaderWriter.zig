const std = @import("std");

const String = @import("string").String;

pub const STDIOReaderWriter = @This();

buffer: STDIOBuffer,
stdio: Stdio,
output: Output,
input: Input,
writer: *std.Io.Writer,
reader: *std.Io.Reader,

pub fn init(self: *@This(), io: std.Io) void {
    self.buffer = .init();
    self.stdio = .init(
        std.Io.File.Writer.init(std.Io.File.stdout(), io, &self.buffer.stdout),
        std.Io.File.Reader.init(std.Io.File.stdin(), io, &self.buffer.stdin),
    );
    self.output = .init(&self.stdio.out.interface);
    self.input = .init(&self.stdio.in.interface);
    self.writer = self.output.writer;
    self.reader = self.input.reader;
}

pub fn print(self: @This(), message: []const u8) !void {
    try self.output.writer.writeAll(message);
    try self.flush();
}

pub fn print_s(self: @This(), string: String) !void {
    try self.output.writer.writeAll(string.str());
    try self.flush();
}

pub fn printf(self: @This(), comptime fmt: []const u8, args: anytype) !void {
    try self.output.writer.print(fmt, args);
    try self.flush();
}

pub fn println(self: @This(), message: []const u8) !void {
    try self.printf("{s}\n", .{message});
}

pub fn println_s(self: @This(), string: *String) !void {
    try self.printf("{s}", .{string.*.str()});
}

pub fn enter(self: @This()) !void {
    try self.println("");
}

pub fn flush(self: @This()) !void {
    try self.output.writer.flush();
}

pub fn scan_s(self: @This(), variable: *String) !void {
    const line: []const u8 = try self.input.reader.takeDelimiterInclusive('\n');
    const value = if (line.len > 0 and line[line.len - 1] == '\n') line[0 .. line.len - 1] else line;

    try variable.*.setStr(value);
}

pub fn scan(self: @This(), buffer: []u8) !void {
    const line: []const u8 = try self.input.reader.takeDelimiterInclusive('\n');
    const value = if (line.len > 0 and line[line.len - 1] == '\n') line[0 .. line.len - 1] else line;

    if (value.len > buffer.len) return error.InputTooLarge;

    @memset(buffer, 0);
    @memcpy(buffer[0..value.len], value);
}

pub fn scan_ar(self: @This(), array: *std.ArrayList(u8)) !void {
    const line: []const u8 = try self.input.reader.takeDelimiterInclusive('\n');
    const value = if (line.len > 0 and line[line.len - 1] == '\n') line[0 .. line.len - 1] else line;

    try array.clearRetainingCapacity();
    try array.appendSliceBounded(value);
}

//TODO Work on scanf
// pub fn scanf(self; @This(), )

pub const STDIOBuffer = struct {
    stdout: [1024]u8,
    stdin: [1024]u8,
    temp: [256]u8,

    pub fn init() @This() {
        return .{
            .stdin = undefined,
            .stdout = undefined,
            .temp = undefined,
        };
    }
};

pub const Stdio = struct {
    out: std.Io.File.Writer,
    in: std.Io.File.Reader,

    pub fn init(output: std.Io.File.Writer, input: std.Io.File.Reader) @This() {
        return .{ .out = output, .in = input };
    }
};

pub const Output = struct {
    writer: *std.Io.Writer,

    pub fn init(writer: *std.Io.Writer) @This() {
        return .{ .writer = writer };
    }
};

pub const Input = struct {
    reader: *std.Io.Reader,

    pub fn init(reader: *std.Io.Reader) @This() {
        return .{ .reader = reader };
    }
};
