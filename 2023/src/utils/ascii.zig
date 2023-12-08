pub const ZeroAsciiDecimalValue: u8 = 48;
pub const NineAsciiDecimalValue: u8 = 57;

pub fn isValidDigitFromAscii(char: u8) bool {
    return if (char >= ZeroAsciiDecimalValue and char <= NineAsciiDecimalValue) true else false;
}
