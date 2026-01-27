const S = @import("S");

pub const Reader = struct {
    F: S.io.FixedBufferStream([]const u8),

    pub fn I(D: []const u8) Reader {
        return .{ .F = S.io.fixedBufferStream(D) };
    }

    pub fn INT(S: *Reader) !i32 {
        var B: [4]u8 = undefined;
        _ = try S.F.reader().readAll(&B);
        return S.mem.readInt(i32, &B, .big);
    }
};
