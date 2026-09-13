# STDIO Reader and Writer library

Thanks for [JakubSzark](https://github.com/JakubSzark/) for creating the awesome [zig-string](https://github.com/JakubSzark/zig-string) library!
Your project is incredibly useful and I would love to use it in the future!

This library is both a reader and writer utility for standard in and out for the **Zig** programming language.
The entire reason this library was made was due to my lack of understanding of Zig's new IO feature.
So, I made this library just for the sake of fun.
Also, it may be useful for others who want to try further improving their Zig knowledge, which is especially me.

## How to use it

```zig
const std = @import("std");
const STDIOReaderWriter = @import("./STDIOReaderWriter.zig");
// ...

// Create and initialize the ReaderWriter
var rw: STDIOReaderWriter = undefined;
rw.init();

// Print into the std.Io.File.stdout()
try rw.println("Hello World!");

// Scan from std.Io.File.stdin() into a mutable array
// Highly recommend here to use zig-string.String instead!
var name: [20]u8 = undefined;
try rw.scan(&name);
try rw.printf("Hello, {s}\n", .{name});


```

## How to install

Add this to your build.zig.zon

```zig
.dependencies = .{
    .STDIOReaderWriter = .{
        .url = "https://github.com/Oncomito/zig-STDIOReaderWriter/releases/main/master.tar.gz",
        // .hash = Suggested by Zig
    }
}

```

And add this to your build.zig

```zig
    const stdioRW = b.dependency("STDIOReaderWriter", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("STDIOReaderWriter", stdioRW.module("STDIOReaderWriter"));

```

You can then import the library into your code like this

```zig
const STDIOReaderWriter = @import("STDIOReaderWriter");
```

## How to Contribute

I am not really actively maintaining this thing, as it was just a fun project to do.
But, if you wanna help me, you can do it!

1. Fork
2. Clone
3. Add Features (Use Zig FMT)
4. Make a Test
5. Pull Request
6. Success!

## Working Features

Expect this library with many flaws and weird things going on. I am no expert when it comes to low-level actually.

| Function           | Description                                                                  |
| ------------------ | ---------------------------------------------------------------------------- |
| enter              | Output a newline                                                             |
| flush              | Clear the buffer and output it to `stdout`                                   |
| init               | Initialize the ReaderWriter (does not return anything)                       |
| print              | Output a `[]const u8` using an internal `std.Io.File.Writer.WriteAll`        |
| print_s            | Output a `zig-string.String` using the same method as print                  |
| printf             | Take a format and arguments and print them (just like `std.debug.print()`)   |
| println            | `print` but automatically append newline                                     |
| println_s          | `print_s` but automatically append newline                                   |
| scan               | Read from stdin as `[]const u8` and copy it to `buffer`                      |
| scan_s             | Read from stdin as `[]const u8` and set `String` to the value                |
| scan_ar            | Read from stdin as `[]const u8`, clear `std.ArrayList`, and append the value |
