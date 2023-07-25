const std = @import("std");

pub fn main() anyerror!void {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var max = [3]i32{ 0, 0, 0 };
    var sum: i32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var num = std.fmt.parseInt(i32, line, 10) catch -1;

        if (num == -1) {
            updateMax(&max, sum);
            sum = 0;
        } else {
            sum += num;
        }
    }

    std.debug.print("Max weight: {d}\n", .{max[0]});
    std.debug.print("Max weight: {d}\n", .{max[0] + max[1] + max[2]});
}

fn updateMax(max: *[3]i32, sum: i32) void {
    if (sum > max[0]) {
        max[2] = max[1];
        max[1] = max[0];
        max[0] = sum;
    } else if (sum > max[1]) {
        max[2] = max[1];
        max[1] = sum;
    } else if (sum > max[2]) {
        max[2] = sum;
    }
}
