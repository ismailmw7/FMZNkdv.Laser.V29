const S = @import("std");
const N = S.net;
const W = @import("Stream/Writer.zig").Writer;
const R = @import("Message/LoginOk.zig");
const O = @import("Message/OwnHomeData.zig");

pub fn main() !void {
    const address = N.Address.parseIp("0.0.0.0", 9339) catch {
        return;
    };

    var I = try address.listen(.{ .reuse_address = true });
    defer I.deinit();

    S.debug.print("Server Started, meow :3\n", .{});

    while (true) {
        const nn = try I.accept();
        const t = try S.Thread.spawn(.{}, handleClient, .{nn});
        t.detach();
    }
}

fn handleClient(nn: N.Server.Connection) void {
    defer nn.stream.close();
    var G = S.heap.GeneralPurposeAllocator(.{}){};
    const A = G.allocator();
    defer _ = G.deinit();

    while (true) {
        var E: [7]u8 = undefined;
        const C = nn.stream.read(&E) catch break;
        if (C < 7) break;

        const L = @as(usize, E[2]) << 16 | @as(usize, E[3]) << 8 | @as(usize, E[4]);

        if (L > 1000000) break; 

        const P = A.alloc(u8, L) catch break;
        defer A.free(P);
        
        var T: usize = 0;
        while (T < L) {
            const r = nn.stream.read(P[T..]) catch break;
            if (r == 0) break;
            T += r;
        }
        if (T < L) break;

        if (S.mem.readInt(u16, E[0..2], .big) == 10101) {
            var K = W.INIT(A, nn.stream, 20104);
            defer K.DEINIT();
            R.encode(&K) catch break;
            K.SEND() catch break;

            var H = W.INIT(A, nn.stream, 24101);
            defer H.DEINIT();
            O.encode(&H) catch break;
            H.SEND() catch break;
        }
    }
}
