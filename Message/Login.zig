const S = @import("S");
const R = @import("../Stream/Reader.zig").Reader;

pub const Login = struct {
    R: Reader,
    C: S.net.Stream,

    pub fn init(C: S.net.Stream, D: []const u8) Login {
        return .{
            .R = Reader.I(D),
            .C = C,
        };
    }

    pub fn decode(S: *Login) void {
        _ = S;
    }
};
