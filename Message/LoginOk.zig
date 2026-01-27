const A = @import("../Stream/Writer.zig").Writer;

pub fn encode(W: *A) !void {
    try W.INT(0, 4);
    try W.INT(0, 4);
    try W.INT(0, 4);
    try W.INT(0, 4);
    try W.STRING("gayfurry");
    try W.STRING(null);
    try W.STRING(null);
    try W.INT(29, 4);
    try W.INT(270, 4);
    try W.INT(1, 4);
    try W.STRING("prod");
    try W.INT(1, 4);
    try W.INT(1, 4);
    try W.INT(62, 4);
    try W.STRING(null);
    try W.STRING(null);
    try W.STRING(null);
    try W.INT(0, 4);
    try W.STRING(null);
    try W.STRING("RU");
    try W.STRING(null);
    try W.INT(1, 4);
    try W.STRING(null);
    try W.STRING(null);
    try W.STRING(null);
    try W.VINT(0, true);
    try W.STRING(null);
    try W.VINT(1, true);
}
