//! Advent of Code - Day 4: Scratchcards
//! https://adventofcode.com/2023/day/4

const std = @import("std");
const print = @import("std").debug.print;
const ArrayList = @import("std").ArrayList;
const GeneralPurposeAllocator = @import("std").heap.GeneralPurposeAllocator;
const splitSequence = @import("std").mem.splitSequence;

const Part = enum { One, Two };

fn getNumMatchingNumbers(winning_numbers: []const u8, scratched_numbers: []const u8) !u64 {
    var winning_numbers_sequence = splitSequence(u8, winning_numbers, " ");
    var scratched_numbers_sequence = splitSequence(u8, scratched_numbers, " ");

    var num_matching_numbers: u64 = 0;
    while (winning_numbers_sequence.next()) |winning_number| {
        if (!std.mem.eql(u8, winning_number, "")) {
            while (scratched_numbers_sequence.next()) |scratched_number| {
                if (std.mem.eql(u8, winning_number, scratched_number)) {
                    num_matching_numbers += 1;
                }
            }
        }
        scratched_numbers_sequence.reset();
    }

    return num_matching_numbers;
}

fn solve(input: []const u8, part: Part) !u64 {
    var games = splitSequence(u8, input, "\n");
    var num_games = try std.math.divCeil(u64, games.buffer.len, games.first().len);
    games.reset();

    var gpa = GeneralPurposeAllocator(.{}){};
    var list = ArrayList(u64).init(gpa.allocator());
    defer list.deinit();

    while (num_games > 0) {
        try list.append(1);
        num_games -= 1;
    }

    var sum: u64 = 0;
    var game_index: u64 = 0;
    while (games.next()) |game| {
        var game_info = splitSequence(u8, game, ": ");
        _ = game_info.first();

        var scratchcards_info = splitSequence(u8, game_info.next().?, " | ");
        var winning_numbers = scratchcards_info.first();
        var scratched_numbers = scratchcards_info.rest();

        switch (part) {
            Part.One => {
                var points: u64 = 0;
                var num_matching_numbers = try getNumMatchingNumbers(winning_numbers, scratched_numbers);

                while (num_matching_numbers > 0) {
                    points = if (points == 0) 1 else points * 2;
                    num_matching_numbers -= 1;
                }

                sum += points;
            },
            Part.Two => {
                var num_matching_numbers = try getNumMatchingNumbers(winning_numbers, scratched_numbers);
                while (num_matching_numbers > 0) {
                    list.items[game_index + num_matching_numbers] += 1 * list.items[game_index];
                    num_matching_numbers -= 1;
                }

                sum += list.items[game_index];
                game_index += 1;
            },
        }
    }

    return sum;
}

// zig build -Dday=04 run
pub fn main() !void {
    const input = @embedFile("input.txt");
    print("Solution Part 1: {d}\n", .{try solve(input, Part.One)});
    print("Solution Part 2: {d}\n", .{try solve(input, Part.Two)});
}

// zig build -Dday=04 test
test "test-input-part-one" {
    const expected: u64 = 13;
    const input =
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    ;

    const result: u64 = try solve(input, Part.One);
    try std.testing.expectEqual(expected, result);
}

test "test-input-part-two" {
    const expected: u64 = 30;
    const input =
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    ;

    const result: u64 = try solve(input, Part.Two);
    try std.testing.expectEqual(expected, result);
}
