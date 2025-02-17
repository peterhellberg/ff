//! Drawing functions, both proxies for `ff.draw<Function>`
//! and convenience functions with `i32` arguments.

const ff = @import("ff.zig");

pub const Arc = ff.drawArc;
pub const Circle = ff.drawCircle;
pub const Ellipse = ff.drawEllipse;
pub const Image = ff.drawImage;
pub const Line = ff.drawLine;
pub const Point = ff.drawPoint;
pub const Rect = ff.drawRect;
pub const RoundedRect = ff.drawRoundedRect;
pub const Sector = ff.drawSector;
pub const SubImage = ff.drawSubImage;
pub const Text = ff.drawText;
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

/// Convenience function for [drawTriangle](#ff.drawTriangle)
pub fn tri(x1: i32, y1: i32, x2: i32, y2: i32, x3: i32, y3: i32, s: ff.Style) void {
    ff.drawTriangle(.{ .x = x1, .y = y1 }, .{ .x = x2, .y = y2 }, .{ .x = x3, .y = y3 }, s);
}
