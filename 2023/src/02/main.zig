//! Advent of Code - Day 2: Cube Conundrum
//! https://adventofcode.com/2023/day/2

const std = @import("std");
const print = @import("std").debug.print;
const eql = @import("std").mem.eql;
const parseInt = @import("std").fmt.parseInt;
const splitSequence = @import("std").mem.splitSequence;

const Part = @import("utils").Part;
const GameConfig = .{ .blue = 14, .green = 13, .red = 12 };

fn checkGameFeasibility(game: []const u8) !bool {
    var game_info = splitSequence(u8, game, ": ");
    _ = game_info.next();

    var sets = splitSequence(u8, game_info.rest(), "; ");
    while (sets.next()) |set| {
        var cubes = splitSequence(u8, set, ", ");
        while (cubes.next()) |cube| {
            var cube_info = splitSequence(u8, cube, " ");
            var count = try parseInt(u32, cube_info.next() orelse unreachable, 10);
            var color = cube_info.next() orelse unreachable;

            if (eql(u8, color, "blue") and count > GameConfig.blue) {
                return false;
            } else if (eql(u8, color, "green") and count > GameConfig.green) {
                return false;
            } else if (eql(u8, color, "red") and count > GameConfig.red) {
                return false;
            }
        }
    }

    return true;
}

fn getGamePower(game: []const u8) !u64 {
    var game_info = splitSequence(u8, game, ": ");
    _ = game_info.next();

    var min_blue_cubes_count: u32 = 0;
    var min_green_cubes_count: u32 = 0;
    var min_red_cubes_count: u32 = 0;

    var sets = splitSequence(u8, game_info.rest(), "; ");
    while (sets.next()) |set| {
        var cubes = splitSequence(u8, set, ", ");
        while (cubes.next()) |cube| {
            var cube_info = splitSequence(u8, cube, " ");
            var count = try parseInt(u32, cube_info.next() orelse unreachable, 10);
            var color = cube_info.next() orelse unreachable;

            if (eql(u8, color, "blue") and count > min_blue_cubes_count) {
                min_blue_cubes_count = count;
            } else if (eql(u8, color, "green") and count > min_green_cubes_count) {
                min_green_cubes_count = count;
            } else if (eql(u8, color, "red") and count > min_red_cubes_count) {
                min_red_cubes_count = count;
            }
        }
    }

    return min_blue_cubes_count * min_green_cubes_count * min_red_cubes_count;
}

fn solve(input: []const u8, part: Part) !u64 {
    var games = splitSequence(u8, input, "\n");

    var sum: u64 = 0;
    var game_index: u64 = 1;
    while (games.next()) |game| {
        switch (part) {
            Part.One => {
                sum += if (try checkGameFeasibility(game)) game_index else 0;
            },
            Part.Two => {
                sum += try getGamePower(game);
            },
        }
        game_index += 1;
    }

    return sum;
}

// zig build -Dday=02 run
pub fn main() !void {
    const input = @embedFile("input.txt");
    print("Part 1 Solution: {d}\n", .{try solve(input, Part.One)});
    print("Part 2 Solution: {d}\n", .{try solve(input, Part.Two)});
}

// zig build -Dday=02 test
test "test-input-part-one" {
    const expected: u64 = 8;
    const input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;

    const result: u64 = try solve(input, Part.One);
    try std.testing.expectEqual(expected, result);
}

test "test-input-part-two" {
    const expected: u64 = 2286;
    const input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;

    const result: u64 = try solve(input, Part.Two);
    try std.testing.expectEqual(expected, result);
}
