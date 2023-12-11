//! Advent of Code - Day 3: Gear Ratios
//! https://adventofcode.com/2023/day/3

const std = @import("std");
const print = @import("std").debug.print;
const splitSequence = @import("std").mem.splitSequence;
const parseInt = @import("std").fmt.parseInt;
const isValidDigitFromAscii = @import("utils").isValidDigitFromAscii;

const Part = @import("utils").Part;

fn isSymbol(c: u8) bool {
    return c != '.' and !isValidDigitFromAscii(c);
}

fn coordToIndex(x: u64, y: u64, axis_limit: u64) u64 {
    return x + ((axis_limit + 1) * y);
}

fn cellFromCoord(grid: []const u8, axis_limit: u64, x: u64, y: u64) u8 {
    return if (x < 0 or y < 0 or x >= axis_limit or y >= axis_limit) 'u' else grid[coordToIndex(x, @as(u64, y), axis_limit)];
}

fn findPartNumberLastIndex(buffer: []const u8, start_index: u64) u64 {
    var index = start_index;
    while (index <= buffer.len - 1) {
        if (!isValidDigitFromAscii(buffer[index])) {
            return index;
        }
        index += 1;
    }
    return buffer.len;
}

fn findPartNumberInitialIndex(buffer: []const u8, start_index: u64) u64 {
    var index = start_index;
    while (index > 0) {
        if (!isValidDigitFromAscii(buffer[index - 1])) {
            return index;
        }
        index -= 1;
    }
    return 0;
}

fn hasAdjacentSymbol(grid: []const u8, axis_limit: u64, y_axis_index: u64, x_axis_index_start: u64, x_axis_index_end: u64) bool {
    if (x_axis_index_end < axis_limit - 1) {
        if (isSymbol(grid[coordToIndex(x_axis_index_end + 1, y_axis_index, axis_limit)])) {
            return true; // Right
        } else if (y_axis_index > 0 and isSymbol(grid[coordToIndex(x_axis_index_end + 1, y_axis_index - 1, axis_limit)])) {
            return true; // Top Right
        } else if (y_axis_index < axis_limit - 1 and isSymbol(grid[coordToIndex(x_axis_index_end + 1, y_axis_index + 1, axis_limit)])) {
            return true; // Bottom Right
        }
    }

    if (y_axis_index < axis_limit - 1) {
        var index = x_axis_index_start;
        while (index <= x_axis_index_end) {
            if (isSymbol(grid[coordToIndex(index, y_axis_index + 1, axis_limit)])) {
                return true; // Bottom
            }
            index += 1;
        }
    }

    if (x_axis_index_start > 0) {
        if (isSymbol(grid[coordToIndex(x_axis_index_start - 1, y_axis_index, axis_limit)])) {
            return true; // Left
        } else if (y_axis_index > 0 and isSymbol(grid[coordToIndex(x_axis_index_start - 1, y_axis_index - 1, axis_limit)])) {
            return true; // Top Left
        } else if (y_axis_index < axis_limit - 1 and isSymbol(grid[coordToIndex(x_axis_index_start - 1, y_axis_index + 1, axis_limit)])) {
            return true; // Bottom Left
        }
    }

    if (y_axis_index > 0) {
        var index = x_axis_index_start;
        while (index <= x_axis_index_end) {
            if (isSymbol(grid[coordToIndex(index, y_axis_index - 1, axis_limit)])) {
                return true; // Top
            }
            index += 1;
        }
    }

    return false;
}

fn getPartNumberFromCoord(grid: []const u8, axis_limit: u64, x: u64, y: u64) !u64 {
    const initialIndex = findPartNumberInitialIndex(grid, coordToIndex(x, y, axis_limit));
    const lastIndex = findPartNumberLastIndex(grid, coordToIndex(x, y, axis_limit));
    return try parseInt(u64, grid[initialIndex..if (initialIndex == lastIndex) lastIndex + 1 else lastIndex], 10);
}

fn getGearRatio(grid: []const u8, axis_limit: u64, x: u64, y: u64) !u64 {
    var buffer: [96]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);

    var part_numbers_set = std.AutoHashMap(u64, void).init(fba.allocator());
    defer part_numbers_set.deinit();

    const adjacent_cells = [8][2]i8{
        [_]i8{ 1, 0 }, // Right
        [_]i8{ 1, 1 }, // Bottom Right
        [_]i8{ 0, 1 }, // Bottom
        [_]i8{ -1, 1 }, // Bottom Left
        [_]i8{ -1, 0 }, // Left
        [_]i8{ -1, -1 }, // Top Left
        [_]i8{ 0, -1 }, // Top
        [_]i8{ 1, -1 }, // Top Right
    };

    for (adjacent_cells) |cell| {
        const cell_x: u64 = @intCast(@as(i64, @intCast(x)) + cell[0]);
        const cell_y: u64 = @intCast(@as(i64, @intCast(y)) + cell[1]);

        if (isValidDigitFromAscii(cellFromCoord(grid, axis_limit, cell_x, cell_y))) {
            const part_number = try getPartNumberFromCoord(grid, axis_limit, cell_x, cell_y);
            try part_numbers_set.put(part_number, {});
        }
    }

    if (part_numbers_set.count() <= 1) {
        return 0;
    }

    var gear_ratio: u64 = 1;
    var iterator = part_numbers_set.iterator();
    while (iterator.next()) |entry| {
        gear_ratio *= entry.key_ptr.*;
    }

    return gear_ratio;
}

fn solve(input: []const u8, part: Part) !u64 {
    var lines = splitSequence(u8, input, "\n");
    var axis_limit: usize = 0;

    var sum: u64 = 0;
    var y_axis_index: u64 = 0;
    while (lines.next()) |line| {
        if (axis_limit == 0) {
            axis_limit = line.len;
        }

        var x_axis_index: u64 = 0;
        while (x_axis_index < line.len) {
            switch (part) {
                Part.One => {
                    if (isValidDigitFromAscii(line[x_axis_index])) {
                        const next_index = findPartNumberLastIndex(line, x_axis_index);
                        const number = try parseInt(u64, line[x_axis_index..next_index], 10);
                        sum += if (hasAdjacentSymbol(lines.buffer, axis_limit, y_axis_index, x_axis_index, next_index - 1)) number else 0;
                        x_axis_index = next_index;
                    } else {
                        x_axis_index += 1;
                    }
                },
                Part.Two => {
                    if (isSymbol(line[x_axis_index])) {
                        sum += try getGearRatio(lines.buffer, axis_limit, x_axis_index, y_axis_index);
                    }
                    x_axis_index += 1;
                },
            }
        }
        y_axis_index += 1;
    }

    return sum;
}

// zig build -Dday=03 run
pub fn main() !void {
    const input = @embedFile("input.txt");
    print("Solution Part 1: {d}\n", .{try solve(input, Part.One)});
    print("Solution Part 2: {d}\n", .{try solve(input, Part.Two)});
}

// zig build -Dday=03 test
test "test-input-part-one" {
    const expected: u64 = 4361;
    const input =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;

    const result: u64 = try solve(input, Part.One);
    try std.testing.expectEqual(expected, result);
}

test "test-input-part-two" {
    const expected: u64 = 467835;
    const input =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;

    const result: u64 = try solve(input, Part.Two);
    try std.testing.expectEqual(expected, result);
}
