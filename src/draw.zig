//! Drawing functions, both proxies for `ff.draw<Function>`
//! and convenience functions with `i32` arguments.

const std = @import("std");
const ff = @import("ff.zig");

/// Alias for [drawArc](#ff.drawArc)
pub const Arc = ff.drawArc;
/// Alias for [drawCircle](#ff.drawCircle)
pub const Circle = ff.drawCircle;
/// Alias for [drawEllipse](#ff.drawEllipse)
pub const Ellipse = ff.drawEllipse;
/// Alias for [flipX](#ff.flipX)
pub const FlipX = ff.flipX;
/// Alias for [flipY](#ff.flipY)
pub const FlipY = ff.flipY;
/// Alias for [drawImage](#ff.drawImage)
pub const Image = ff.drawImage;
/// Alias for [drawLine](#ff.drawLine)
pub const Line = ff.drawLine;
/// Alias for [drawNineSlice](#ff.drawNineSlice)
pub const NineSlice = ff.drawNineSlice;
/// Alias for [drawPoint](#ff.drawPoint)
pub const Point = ff.drawPoint;
/// Alias for [drawQR](#ff.drawQR)
pub const QR = ff.drawQR;
/// Alias for [drawRect](#ff.drawRect)
pub const Rect = ff.drawRect;
/// Alias for [drawRoundedRect](#ff.drawRoundedRect)
pub const RoundedRect = ff.drawRoundedRect;
/// Alias for [drawSector](#ff.drawSector)
pub const Sector = ff.drawSector;
/// Alias for [drawSubImage](#ff.drawSubImage)
pub const SubImage = ff.drawSubImage;
/// Alias for [drawSubTile](#ff.drawSubTile)
pub const SubTile = ff.drawSubTile;
/// Alias for [drawText](#ff.drawText)
pub const Text = ff.drawText;
/// Alias for [drawTriangle](#ff.drawTriangle)
pub const Triangle = ff.drawTriangle;

/// Convenience function for [drawArc](#ff.drawArc)
pub fn arc(x: i32, y: i32, d: i32, angle: ff.Angle, sweep: ff.Angle, s: ff.Style) void {
    ff.drawArc(.{ .x = x, .y = y }, d, angle, sweep, s);
}

/// Convenience function for [drawCircle](#ff.drawCircle)
pub fn circ(x: i32, y: i32, d: i32, s: ff.Style) void {
    ff.drawCircle(.{ .x = x, .y = y }, d, s);
}

/// Convenience function for [drawEllipse](#ff.drawEllipse)
pub fn elli(x: i32, y: i32, w: i32, h: i32, s: ff.Style) void {
    ff.drawEllipse(.{ .x = x, .y = y }, .{ .width = w, .height = h }, s);
}

/// Convenience function for [drawLine](#ff.drawLine)
pub fn line(x1: i32, y1: i32, x2: i32, y2: i32, ls: ff.LineStyle) void {
    ff.drawLine(.{ .x = x1, .y = y1 }, .{ .x = x2, .y = y2 }, ls);
}

/// Convenience function for [drawRect](#ff.drawRect)
pub fn rect(x: i32, y: i32, w: i32, h: i32, s: ff.Style) void {
    ff.drawRect(.{ .x = x, .y = y }, .{ .width = w, .height = h }, s);
}

/// Convenience function for [drawRoundedRect](#ff.drawRoundedRect)
pub fn rrect(x: i32, y: i32, w: i32, h: i32, cw: i32, ch: i32, s: ff.Style) void {
    ff.drawRoundedRect(.{ .x = x, .y = y }, .{ .width = w, .height = h }, .{ .width = cw, .height = ch }, s);
}

/// Convenience function for [drawSector](#ff.drawSector)
pub fn sect(x: i32, y: i32, d: i32, angle: ff.Angle, sweep: ff.Angle, s: ff.Style) void {
    ff.drawSector(.{ .x = x, .y = y }, d, angle, sweep, s);
}

/// Convenience function for [drawTriangle](#ff.drawTriangle)
pub fn tri(x1: i32, y1: i32, x2: i32, y2: i32, x3: i32, y3: i32, s: ff.Style) void {
    ff.drawTriangle(.{ .x = x1, .y = y1 }, .{ .x = x2, .y = y2 }, .{ .x = x3, .y = y3 }, s);
}

test "aliases and convenience functions resolve" {
    std.testing.refAllDecls(@This());

    const s: ff.Style = .{ .fill_color = .white };
    const ls: ff.LineStyle = .{ .color = .white };

    arc(0, 0, 4, .zero, .full_circle, s);
    circ(0, 0, 4, s);
    elli(0, 0, 4, 4, s);
    line(0, 0, 1, 1, ls);
    rect(0, 0, 4, 4, s);
    rrect(0, 0, 4, 4, 1, 1, s);
    sect(0, 0, 4, .zero, .full_circle, s);
    tri(0, 0, 1, 1, 2, 2, s);
}
