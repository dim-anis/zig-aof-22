const std = @import("std");
const split = std.mem.splitScalar;
const eql = std.mem.eql;

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    const allocator = std.heap.page_allocator;
    const memory = try allocator.alloc(u8, 100);
    defer allocator.free(memory);
    var charMap = std.StringHashMap(u8).init(allocator);

    try charMap.put("A", 1); // rock
    try charMap.put("B", 2); // paper
    try charMap.put("C", 3); // scissors

    try charMap.put("X", 1); // rock
    try charMap.put("Y", 2); // paper
    try charMap.put("Z", 3); // scissors

    try charMap.put("draw", 3);
    try charMap.put("win", 6);
    try charMap.put("loss", 0);

    var points: u16 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var chars = split(u8, line, ' ');
        const elf_choose = chars.next().?;
        const human_choose = chars.next().?;

        // result draw
        if (std.meta.eql(charMap.get(elf_choose), charMap.get(human_choose))) {
            std.debug.print("draw: {d}\n", .{points});
            const drawPoints = charMap.get("draw").? + charMap.get(human_choose).?;
            points += drawPoints;
            // result win
        } else if (eql(u8, elf_choose, "A") and eql(u8, human_choose, "Y") or
            eql(u8, elf_choose, "B") and eql(u8, human_choose, "Z") or
            eql(u8, elf_choose, "C") and eql(u8, human_choose, "X"))
        {
            std.debug.print("win: {d}\n", .{points});
            const winPoints = charMap.get("win").? + charMap.get(human_choose).?;
            points += winPoints;
            // result loss
        } else {
            std.debug.print("loss: {d}\n", .{points});
            points += charMap.get(human_choose).?;
        }
    }

    std.debug.print("The result is: {d}\n", .{points});
}
