const S = @import("std");

pub const Writer = struct {
    B: S.ArrayListUnmanaged(u8),
    I: i16,
    C: S.net.Stream,
    A: S.mem.Allocator,

    pub fn INIT(A: S.mem.Allocator, C: S.net.Stream, I: i16) Writer {
        return .{
            .B = S.ArrayListUnmanaged(u8){},
            .I = I,
            .C = C,
            .A = A,
        };
    }

    pub fn DEINIT(self: *Writer) void {
        self.B.deinit(self.A);
    }

    pub fn INT(self: *Writer, data: u32, len: usize) !void {
        var F: [4]u8 = undefined;
        S.mem.writeInt(u32, &F, data, .big);
        try self.B.appendSlice(self.A, F[4 - len ..]);
    }

    pub fn UINT8(self: *Writer, data: u8) !void {
        try self.B.append(self.A, data);
    }

    pub fn STRING(self: *Writer, string: ?[]const u8) !void {
        if (string) |s| {
            try self.INT(@intCast(s.len), 4);
            try self.B.appendSlice(self.A, s);
        } else {
            try self.INT(0xFFFFFFFF, 4);
        }
    }

    pub fn VINT(self: *Writer, value: i32, rotate: bool) !void {
        var T = rotate;
        var D = @as(u32, @bitCast((value << 1) ^ (value >> 31)));
        if (value == 0) {
            try self.UINT8(0);
            return;
        }
        while (D != 0) {
            var b = @as(u8, @truncate(D & 0x7F));
            if (D >= 0x80) b |= 0x80;
            if (T) {
                T = false;
                const lsb = b & 0x01;
                const msb = (b & 0x80) >> 7;
                b >>= 1;
                b &= ~@as(u8, 0xC0);
                b = b | (msb << 7) | (lsb << 6);
            }
            try self.B.append(self.A, b);
            D >>= 7;
        }
    }

    pub fn SEND(self: *Writer) !void {
        var H: [7]u8 = undefined;
        S.mem.writeInt(i16, H[0..2], self.I, .big);
        H[2] = @truncate(self.B.items.len >> 16);
        H[3] = @truncate(self.B.items.len >> 8);
        H[4] = @truncate(self.B.items.len);
        S.mem.writeInt(u16, H[5..7], 1, .big); 

        try self.C.writeAll(&H);
        try self.C.writeAll(self.B.items);
        try self.C.writeAll(&[_]u8{ 0xFF, 0xFF, 0, 0, 0, 0, 0 });
    }
};
