//! Advent of Code - Day 1: Trebuchet?!
//! https://adventofcode.com/2023/day/1

const std = @import("std");
const print = @import("std").debug.print;
const isValidDigitFromAscii = @import("utils").isValidDigitFromAscii;

const ZeroAsciiDecimalValue = @import("utils").ZeroAsciiDecimalValue;

const Digit = struct {
    slug: []const u8,
    value: u8,
};

const digits = [_]Digit{
    .{ .slug = "one", .value = 1 },
    .{ .slug = "two", .value = 2 },
    .{ .slug = "three", .value = 3 },
    .{ .slug = "four", .value = 4 },
    .{ .slug = "five", .value = 5 },
    .{ .slug = "six", .value = 6 },
    .{ .slug = "seven", .value = 7 },
    .{ .slug = "eight", .value = 8 },
    .{ .slug = "nine", .value = 9 },
};

fn isValidDigitFromSlug(slug: []const u8, str: []const u8) bool {
    return std.mem.eql(u8, slug, str);
}

fn getCalibrationValue(line: []const u8) u64 {
    var first_digit: u32 = 0;
    var last_digit: u32 = undefined;

    var i: usize = 0;
    while (i < line.len) : (i += 1) {
        if (isValidDigitFromAscii(line[i])) {
            last_digit = line[i] - ZeroAsciiDecimalValue;
            if (first_digit == 0) {
                first_digit = last_digit;
            }
        } else {
            for (digits) |digit| {
                if (i + digit.slug.len <= line.len) {
                    if (isValidDigitFromSlug(digit.slug, line[i .. i + digit.slug.len])) {
                        last_digit = digit.value;
                        if (first_digit == 0) {
                            first_digit = last_digit;
                        }
                    }
                }
            }
        }
    }

    return (first_digit * 10) + last_digit;
}

fn solve(input: []const u8) u64 {
    var lines = std.mem.split(u8, input, "\n");

    var sum: u64 = 0;
    while (lines.next()) |line| {
        sum += getCalibrationValue(line);
    }

    return sum;
}

// zig build -Dday=01 run
pub fn main() !void {
    const input = @embedFile("input.txt");
    print("Solution: {d}\n", .{solve(input)});
}

// zig build -Dday=01 test
test "test-input-part-one" {
    const expected: u64 = 142;
    const input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;

    const result = solve(input);
    try std.testing.expectEqual(expected, result);
}

test "test-input-part-two" {
    const expected: u64 = 281;
    const input =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;

    const result = solve(input);
    try std.testing.expectEqual(expected, result);
}
