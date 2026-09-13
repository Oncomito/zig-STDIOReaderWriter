const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const expectEqualStrings = std.testing.expectEqualStrings;

const STDIOReaderWriter = @import("STDIOReaderWriter");

test "Basic Usage" {
    // Create an STDIOReaderWriter object
    // Object must be a var
    var ReaderWriter: STDIOReaderWriter = undefined;
    ReaderWriter.init(std.testing.io);

    // Print a string to std.Io.File.stdout()
    // It might return an error, therefore try keyword is necessary
    try ReaderWriter.println("Hello World!");
}
