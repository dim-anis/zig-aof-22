const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() anyerror!void {
    const file = try std.fs.cwd().openFile("data2.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var max: i32 = 0;
    var sum: i32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var num = std.fmt.parseInt(i32, line, 10) catch -1;

        if (num == -1) {
            if (sum > max) {
                max = sum;
            }

            sum = 0;
        } else {
            sum += num;
        }
    }

    std.debug.print("Max weight: {d}\n", .{max});
}
