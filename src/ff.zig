//! **ff** is a small [Zig](https://ziglang.org/) ⚡ module meant for
//! making [Firefly Zero](https://fireflyzero.com/) games 🎮 _(and other apps)_
//!
//! _Initially based on [firefly-zig](https://github.com/firefly-zero/firefly-zig)_
//!
//! #### Examples from <https://play.c7.se/ff/>
//!
//!     [![](https://play.c7.se/ff/fp8x8/shots/1.png)](https://play.c7.se/ff/fp8x8/)
//!     [![](https://play.c7.se/ff/rng/shots/2.png)](https://play.c7.se/ff/rng/)
//!
//! #### You might want to install the [ff-init](https://github.com/peterhellberg/ff-init) tool and use that instead of manually creating the files for your game.
//!

const std = @import("std");

comptime {
    std.testing.refAllDecls(@This());
}

const bindings = @import("bindings.zig");

// Audio functions
pub const audio = @import("audio.zig");

/// Drawing functions
pub const draw = @import("draw.zig");

/// Width of the screen is **240** pixels.
pub const width: i32 = 240;

/// Height of the screen is **160** pixels.
pub const height: i32 = 160;

/// An approximation of the mathematical constant π.
const pi: f32 = 3.14159265358979323846264338327950288;

/// An approximation of the mathematical constant τ.
const tau: f32 = 6.28318530717958647692528676655900577;

/// Vec is a `@Vector(2, f32)`
pub const Vec = @Vector(2, f32);

/// A point on the screen, containing x and y.
pub const Point = struct {
    x: i32 = 0,
    y: i32 = 0,

    /// new creates a new Point with the given x and y.
    pub fn new(x: i32, y: i32) Point {
        return .{
            .x = x,
            .y = y,
        };
    }

    /// min creates a Point with x and y both set to 0.
    pub fn min() Point {
        return .{
            .x = 0,
            .y = 0,
        };
    }

    /// max creates a Point with x=width and y=height.
    pub fn max() Point {
        return .{
            .x = width,
            .y = height,
        };
    }

    /// center creates a Point with x=width/2 and y=height/2.
    pub fn center() Point {
        return .{
            .x = width / 2,
            .y = height / 2,
        };
    }

    /// from_vec creates a Point based on the provided Vec.
    pub fn from_vec(v: Vec) Point {
        return .{
            .x = @intFromFloat(v[0]),
            .y = @intFromFloat(v[1]),
        };
    }

    /// add creates a Point by adding the other Point to self.
    pub fn add(self: Point, other: Point) Point {
        return .{
            .x = self.x + other.x,
            .y = self.y + other.y,
        };
    }

    /// sub creates a Point by subtracting the other Point from self.
    pub fn sub(self: Point, other: Point) Point {
        return .{
            .x = self.x - other.x,
            .y = self.y - other.y,
        };
    }

    /// mul creates a Point by multiplying the other Point with self.
    pub fn mul(self: Point, other: Point) Point {
        return .{
            .x = self.x * other.x,
            .y = self.y * other.y,
        };
    }

    /// eql checks if the other Point is equal to self.
    pub fn eql(self: Point, other: Point) bool {
        return self.x == other.x and self.y == other.y;
    }

    /// dot calculates the dot product for self and the other Point.
    pub fn dot(self: Point, other: Point) f32 {
        const p = self.mul(other);

        return @floatFromInt(p.x + p.y);
    }

    /// len calculates the length of self.
    pub fn len(self: Point) f32 {
        return @sqrt(self.dot(self));
    }

    /// vec creates a Vec based on self.
    pub fn vec(self: Point) Vec {
        return .{
            @floatFromInt(self.x),
            @floatFromInt(self.y),
        };
    }

    /// lerp creates a Point between self and other Point, linearly interpolated by t.
    pub fn lerp(self: Point, other: Point, t: f32) Point {
        const from = self.vec();
        const to = other.vec();

        return from_vec(from + (to - from) * @as(Vec, @splat(t)));
    }

    /// scale creates a Point by scaling it by the given scalar.
    pub fn scale(self: Point, scalar: f32) Point {
        return from_vec(self.vec() * @as(Vec, @splat(scalar)));
    }

    /// rect creates a Rect with the given Size at self.
    pub fn rect(self: Point, size: Size) Rect {
        return .{
            .point = self,
            .size = size,
        };
    }

    /// draw the Point in the given Color.
    pub fn draw(self: Point, c: Color) void {
        drawPoint(self, c);
    }
};

test "Point.lerp returns expected results" {
    const tests = [_]struct {
        e: Point,
        f: f32,
        a: Point,
        b: Point,
    }{
        .{ .e = Point.new(15, 15), .f = 0.5, .a = Point.new(10, 10), .b = Point.new(20, 20) },
        .{ .e = Point.new(15, 17), .f = 0.5, .a = Point.new(10, 15), .b = Point.new(20, 20) },
        .{ .e = Point.new(13, 13), .f = 0.3, .a = Point.new(10, 10), .b = Point.new(20, 20) },
    };

    for (tests, 0..) |t, i| {
        const actual = t.a.lerp(t.b, t.f);

        try std.testing.expectEqual(t.e, actual);

        if (false) {
            std.debug.print("test {d}: {}.lerp({}, {}) = {}\n", .{ i, t.a, t.b, t.f, actual });
        }
    }
}

test "Point.scale returns expected results" {
    const tests = [_]struct {
        p: Point,
        s: f32,
        e: Point,
    }{
        .{ .p = Point.new(10, 10), .s = 0.5, .e = Point.new(5, 5) },
        .{ .p = Point.new(10, 15), .s = 2, .e = Point.new(20, 30) },
        .{ .p = Point.new(10, 10), .s = 10, .e = Point.new(100, 100) },
    };

    for (tests, 0..) |t, i| {
        const actual = t.p.scale(t.s);

        try std.testing.expectEqual(t.e, actual);

        if (false) {
            std.debug.print("test {d}: {}.scale({d}) -> {}\n", .{ i, t.p, t.s, actual });
        }
    }
}

/// Size of something, containing width and height.
pub const Size = struct {
    width: i32 = 1,
    height: i32 = 1,

    /// new creates a new Size with the given w and h.
    pub fn new(w: i32, h: i32) Size {
        return .{
            .width = w,
            .height = h,
        };
    }

    /// vec creates a Vec based on self.
    pub fn vec(self: Size) Vec {
        return .{
            @floatFromInt(self.width),
            @floatFromInt(self.height),
        };
    }

    /// rect creates a Rect with the given Point and size self.
    pub fn rect(self: Size, point: Point) Rect {
        return .{
            .point = point,
            .size = self,
        };
    }
};

/// Rect is a rectangle based on a [Point](#ff.Point) and a [Size](#ff.Size)
pub const Rect = struct {
    point: Point = .{},
    size: Size = .{},

    /// new creates a new Rect with the given x, y, w and h.
    pub fn new(x: i32, y: i32, w: i32, h: i32) Rect {
        return .{
            .point = .{ .x = x, .y = y },
            .size = .{ .width = w, .height = h },
        };
    }

    /// min creates a Point for the top left of the rectangle.
    pub fn min(self: Rect) Point {
        return self.point;
    }

    /// max creates a Point for the bottom right of the rectangle.
    pub fn max(self: Rect) Point {
        return self.point.add(.{
            .x = self.size.width,
            .y = self.size.height,
        });
    }

    /// contains checks if the given Point is inside the Rect or not.
    pub fn contains(self: Rect, p: Point) bool {
        const tl = self.min();
        const br = self.max();

        return (p.x >= tl.x and p.x <= br.x and p.y >= tl.y and p.y <= br.y);
    }

    /// draw the Rect in the given Style.
    pub fn draw(self: Rect, s: Style) void {
        drawRect(self.point, self.size, s);
    }
};

test "Rect.contains returns expected results" {
    const tests = [_]struct {
        e: bool,
        r: Rect,
        p: Point,
    }{
        .{ .e = true, .r = Rect.new(0, 0, 10, 10), .p = Point.new(5, 5) },
        .{ .e = true, .r = Rect.new(0, 0, 10, 10), .p = Point.new(5, 10) },
        .{ .e = true, .r = Rect.new(0, 0, 10, 10), .p = Point.new(10, 10) },
        .{ .e = false, .r = Rect.new(0, 0, 10, 10), .p = Point.new(15, 10) },
        .{ .e = false, .r = Rect.new(10, 10, 10, 10), .p = Point.new(5, 5) },
        .{ .e = true, .r = Rect.new(10, 10, 10, 10), .p = Point.new(15, 15) },
    };

    for (tests, 0..) |t, i| {
        try std.testing.expectEqual(t.e, t.r.contains(t.p));

        if (false) {
            std.debug.print("test {d}: r.contains({}) != {}\n", .{ i, t.p, t.e });
        }
    }
}

/// Angle of something,
/// can be created [from_degrees](#ff.Angle.from_degrees)
/// and [from_radians](#ff.Angle.from_radians)
pub const Angle = struct {
    radians: f32,

    /// The 360° angle.
    pub const full_circle: Angle = Angle(tau);
    /// The 180° angle.
    pub const half_circle: Angle = Angle(pi);
    /// The 90° angle.
    pub const quarter_circle: Angle = Angle(pi / 2.0);
    /// The 0° angle.
    pub const zero: Angle = Angle(0.0);

    /// An angle in radians where Tau (doubled Pi) is the full circle.
    pub fn from_radians(r: f32) Angle {
        return Angle{r};
    }

    /// An angle in degrees where 360.0 is the full circle.
    pub fn from_degrees(d: f32) Angle {
        return Angle{d * pi / 180.0};
    }
};

/// RGB color value containing r, g, and b.
///
/// Can be created [from_hex](#ff.RGB.from_hex).
pub const RGB = struct {
    r: u8 = 0,
    g: u8 = 0,
    b: u8 = 0,

    /// A RGB color for the given hexadecimal number.
    pub fn from_hex(hex: u32) RGB {
        return .{
            .r = @intCast(hex >> 16 & 0xFF),
            .g = @intCast(hex >> 8 & 0xFF),
            .b = @intCast(hex & 0xFF),
        };
    }
};

/// Color enumeration.
pub const Color = enum(i32) {
    /// No color (100% transparency).
    none,
    /// Black default: #1A1C2C.
    black,
    /// Purple default: #5D275D.
    purple,
    /// Red default: #B13E53.
    red,
    /// Orange default: #EF7D57.
    orange,
    /// Yellow default: #FFCD75.
    yellow,
    /// Light green default: #A7F070.
    light_green,
    /// Green default: #38B764.
    green,
    /// Dark green default: #257179.
    dark_green,
    /// Dark blue default: #29366F.
    dark_blue,
    /// Blue default: #3B5DC9.
    blue,
    /// Light blue default: #41A6F6.
    light_blue,
    /// Cyan default: #73EFF7.
    cyan,
    /// White default: #F4F4F4.
    white,
    /// Light gray default: #94B0C2.
    light_gray,
    /// Gray default: #566C86.
    gray,
    /// Dark gray default: #333C57.
    dark_gray,

    /// screen clear the screen with the Color.
    pub fn screen(self: Color) void {
        clearScreen(self);
    }

    /// set the Color to the provided RGB value.
    pub fn set(self: Color, v: RGB) void {
        setColor(self, v);
    }

    /// hex sets the Color to the provided HEX value.
    pub fn hex(self: Color, h: u32) void {
        setColor(self, RGB.from_hex(h));
    }
};

/// Palette of all the available colors.
///
/// The default palette is based on
/// https://lospec.com/palette-list/sweetie-16
///
pub const Palette = struct {
    black: u32 = 0x1A1C2C,
    purple: u32 = 0x5D275D,
    red: u32 = 0xB13E53,
    orange: u32 = 0xEF7D57,
    yellow: u32 = 0xFFCD75,
    light_green: u32 = 0xA7F070,
    green: u32 = 0x38B764,
    dark_green: u32 = 0x257179,
    dark_blue: u32 = 0x29366F,
    blue: u32 = 0x3B5DC9,
    light_blue: u32 = 0x41A6F6,
    cyan: u32 = 0x73EFF7,
    white: u32 = 0xF4F4F4,
    light_gray: u32 = 0x94B0C2,
    gray: u32 = 0x566C86,
    dark_gray: u32 = 0x333C57,

    // set each Color based on the Palette.
    pub fn set(self: Palette) void {
        setColorHex(.black, self.black);
        setColorHex(.purple, self.purple);
        setColorHex(.red, self.red);
        setColorHex(.orange, self.orange);
        setColorHex(.yellow, self.yellow);
        setColorHex(.light_green, self.light_green);
        setColorHex(.green, self.green);
        setColorHex(.dark_green, self.dark_green);
        setColorHex(.dark_blue, self.dark_blue);
        setColorHex(.blue, self.blue);
        setColorHex(.light_blue, self.light_blue);
        setColorHex(.cyan, self.cyan);
        setColorHex(.white, self.white);
        setColorHex(.light_gray, self.light_gray);
        setColorHex(.gray, self.gray);
        setColorHex(.dark_gray, self.dark_gray);
    }
};

pub const Style = struct {
    fill_color: Color = .none,
    stroke_color: Color = .none,
    stroke_width: i32 = 0,
};

pub const LineStyle = struct {
    color: Color = .none,
    width: i32 = 1,
};

pub const File = []u8;
pub const Font = File;
pub const Image = File;
pub const Canvas = Image;
pub const String = []const u8;
pub const Stash = []u8;

pub const SubImage = struct {
    point: Point,
    size: Size,
    raw: []u8,
};

pub const Pad = struct {
    x: i32,
    y: i32,
};

/// Buttons represent the current button state for [Peer](#ff.Peer) (such as [me](#ff.getMe)).
pub const Buttons = struct {
    /// South button
    s: bool,
    /// East button
    e: bool,
    /// West button
    w: bool,
    /// North button
    n: bool,
    /// Menu button
    menu: bool,
};

/// Peer represents a user connected to the app,
/// could be yourself ([me](#ff.getMe)), someone else, or everyone combined.
pub const Peer = struct {
    /// ID of the Peer.
    id: u8,

    /// The combined Peer.
    pub const combined = Peer{ .id = 0xFF };

    /// Check if two Peers are the same.
    pub fn eq(self: Peer, other: Peer) bool {
        return self.id == other.id;
    }
};

/// Peers represents a list of Peer.
pub const Peers = struct {
    peers: u32,

    /// Check if the Peers contain the given Peer.
    pub fn contains(self: Peers, p: Peer) bool {
        return (self.peers >> p.id) & 1 != 0;
    }

    /// Return how many Peers there currently are.
    pub fn len(self: Peers) u32 {
        return @popCount(self.peers);
    }

    /// Iterator for Peers.
    pub fn iter(self: Peers) PeersIter {
        return PeersIter{ .peer = 0, .peers = self.peers };
    }
};

/// Iterator for Peers.
pub const PeersIter = struct {
    peer: u8,
    peers: u32,

    /// Next Peer, or `null`.
    pub fn next(self: *PeersIter) ?Peer {
        while (self.peers != 0) {
            const peer = self.peer;
            const peers = self.peers;
            self.peer += 1;
            self.peers >>= 1;
            if (peers & 1 != 0) {
                return Peer{ .id = peer };
            }
        }
        return null;
    }
};

/// A Badge are an achievement that the game rewards to the player for doing some action.
pub const Badge = u8;

/// A Board (aka scoreboard or leaderboard) keep track of best scores of the player and their friends.
pub const Board = u8;

pub const Progress = struct {
    /// How many points the player already has.
    done: u16,
    /// How many points the player needs to earn the badge.
    goal: u16,

    // Check if Progress has been earned or not.
    pub fn earned(self: Progress) bool {
        return self.done >= self.goal;
    }
};

/// Fill the whole frame with the given color.
pub fn clearScreen(c: Color) void {
    bindings.clear_screen(@intFromEnum(c));
}

/// Set a color value in the palette.
pub fn setColor(c: Color, v: RGB) void {
    bindings.set_color(@intFromEnum(c), v.r, v.g, v.b);
}

/// Set a color value in the palette, using a hexadecimal value.
pub fn setColorHex(c: Color, hex: u32) void {
    setColor(c, RGB.from_hex(hex));
}

/// Set a single point (1 pixel is scaling is 1) on the frame.
pub fn drawPoint(p: Point, c: Color) void {
    bindings.draw_point(p.x, p.y, @intFromEnum(c));
}

/// Draw a straight line from point a to point b.
pub fn drawLine(a: Point, b: Point, s: LineStyle) void {
    bindings.draw_line(a.x, a.y, b.x, b.y, @intFromEnum(s.color), s.width);
}

/// Draw a rectangle filling the given bounding box.
pub fn drawRect(p: Point, b: Size, s: Style) void {
    bindings.draw_rect(
        p.x,
        p.y,
        b.width,
        b.height,
        @intFromEnum(s.fill_color),
        @intFromEnum(s.stroke_color),
        s.stroke_width,
    );
}

/// Draw a rectangle with rounded corners.
pub fn drawRoundedRect(p: Point, b: Size, corner: Size, s: Style) void {
    bindings.draw_rounded_rect(
        p.x,
        p.y,
        b.width,
        b.height,
        corner.width,
        corner.height,
        @intFromEnum(s.fill_color),
        @intFromEnum(s.stroke_color),
        s.stroke_width,
    );
}

/// Draw a circle with the given diameter.
pub fn drawCircle(p: Point, d: i32, s: Style) void {
    bindings.draw_circle(
        p.x,
        p.y,
        d,
        @intFromEnum(s.fill_color),
        @intFromEnum(s.stroke_color),
        s.stroke_width,
    );
}

/// Draw an ellipse (oval).
pub fn drawEllipse(p: Point, b: Size, s: Style) void {
    bindings.draw_ellipse(
        p.x,
        p.y,
        b.width,
        b.height,
        @intFromEnum(s.fill_color),
        @intFromEnum(s.stroke_color),
        s.stroke_width,
    );
}

/// Draw a triangle.
///
/// The order of points doesn't matter.
pub fn drawTriangle(a: Point, b: Point, c: Point, s: Style) void {
    bindings.draw_triangle(
        a.x,
        a.y,
        b.x,
        b.y,
        c.x,
        c.y,
        @intFromEnum(s.fill_color),
        @intFromEnum(s.stroke_color),
        s.stroke_width,
    );
}

/// Draw an arc.
pub fn drawArc(p: Point, d: i32, start: Angle, sweep: Angle, s: Style) void {
    bindings.draw_arc(
        p.x,
        p.y,
        d,
        start.radians,
        sweep.radians,
        @intFromEnum(s.fill_color),
        @intFromEnum(s.stroke_color),
        s.stroke_width,
    );
}

/// Draw a sector.
pub fn drawSector(p: Point, d: i32, start: Angle, sweep: Angle, s: Style) void {
    bindings.draw_sector(
        p.x,
        p.y,
        d,
        start.radians,
        sweep.radians,
        @intFromEnum(s.fill_color),
        @intFromEnum(s.stroke_color),
        s.stroke_width,
    );
}

/// Render text using the given font.
///
/// Unlike in the other drawing functions, here [Point] points not to the top-left corner
/// but to the baseline start position.
pub fn drawText(t: String, f: Font, p: Point, c: Color) void {
    bindings.draw_text(
        @intFromPtr(t.ptr),
        t.len,
        @intFromPtr(f.ptr),
        f.len,
        p.x,
        p.y,
        @intFromEnum(c),
    );
}

/// Render an image using the given colors.
pub fn drawImage(i: Image, p: Point) void {
    bindings.draw_image(@intFromPtr(i.ptr), i.len, p.x, p.y);
}

/// Draw a subregion of an image.
///
/// Most often used to draw a sprite from a sprite atlas.
pub fn drawSubImage(i: SubImage, p: Point) void {
    bindings.draw_sub_image(
        @intFromPtr(i.raw.ptr),
        i.raw.len,
        p.x,
        p.y,
        i.point.x,
        i.point.y,
        i.size.width,
        i.size.height,
    );
}

/// Set canvas to be used for all subsequent drawing operations.
pub fn setCanvas(c: Canvas) void {
    bindings.set_canvas(@intFromPtr(c.ptr), c.len);
}

/// Unset canvas set by [`set_canvas`]. All subsequent drawing operations will target frame buffer.
pub fn unsetCanvas() void {
    bindings.unset_canvas();
}

/// Get the current touchpad state.
pub fn readPad(p: Peer) ?Pad {
    const raw = bindings.read_pad(p.id);
    if (raw == 0xffff) {
        return null;
    }
    return Pad{
        .x = @intCast(@as(i16, @truncate(raw >> 16))),
        .y = @intCast(@as(i16, @truncate(raw & 0xFFFF))),
    };
}

/// Get the currently pressed buttons.
pub fn readButtons(p: Peer) Buttons {
    const raw = bindings.read_buttons(p.id);
    return Buttons{
        .s = raw & 1 != 0,
        .e = (raw >> 1) & 1 != 0,
        .w = (raw >> 2) & 1 != 0,
        .n = (raw >> 3) & 1 != 0,
        .menu = (raw >> 4) & 1 != 0,
    };
}

/// Get a file size in the rom or data dir.
///
/// If the file does not exist, 0 is returned.
pub fn getFileSize(path: String) u32 {
    return bindings.get_file_size(@intFromPtr(path.ptr), path.len);
}

/// Read the whole file with the given name into the given buffer.
///
/// If the file size is not known in advance (and so the buffer has to be allocated
/// dynamically), consider using loadFileBuf() instead.
pub fn loadFile(path: String, buf: []u8) []u8 {
    const size = bindings.load_file(@intFromPtr(path.ptr), path.len, @intFromPtr(buf.ptr), buf.len);
    return buf[0..size];
}

/// Read the whole file with the given name.
///
/// If you have a pre-allocated buffer of the right size, use loadFile() instead.
///
/// error.FileNotFound is returned if the file does not exist.
pub fn loadFileBuf(path: String, alloc: std.mem.Allocator) ![]u8 {
    const size = bindings.get_file_size(@intFromPtr(path.ptr), path.len);
    if (size == 0) {
        return error.FileNotFound;
    }
    const buf = try alloc.alloc(u8, size);
    _ = bindings.load_file(@intFromPtr(path.ptr), path.len, @intFromPtr(buf.ptr), buf.len);
    return buf;
}

/// Write the buffer into the given file in the data dir.
///
/// If the file exists, it will be overwritten.
/// If it doesn't exist, it will be created.
pub fn dumpFile(path: String, buf: []const u8) void {
    _ = bindings.dump_file(@intFromPtr(path.ptr), path.len, @intFromPtr(buf.ptr), buf.len);
}

/// Remove file (if exists) with the given name from the data dir.
pub fn removeFile(path: String) void {
    bindings.remove_file(@intFromPtr(path.ptr), path.len);
}

/// Add a custom item on the app menu.
///
/// The `i` index is the value passed into the `handle_menu` callback
/// when the menu item is selected by the user.
/// Its value doesn't have to be unique or continious.
pub fn addMenuItem(i: u8, t: String) void {
    bindings.add_menu_item(i, @intFromPtr(t.ptr), t.len);
}

/// Remove a custom menu item with the given index.
pub fn removeMenuItem(i: u8) void {
    bindings.remove_menu_item(i);
}

/// Open the app menu.
///
/// It will be opened before the next update.
/// The current update and then render will proceed as planned.
pub fn openMenu() void {
    bindings.open_menu();
}

/// Log a debug message.
pub fn logDebug(t: String) void {
    bindings.log_debug(@intFromPtr(t.ptr), t.len);
}

/// Log an error message.
pub fn logError(t: String) void {
    bindings.log_error(@intFromPtr(t.ptr), t.len);
}

/// Set the random seed.
pub fn setSeed(seed: u32) void {
    bindings.set_seed(seed);
}

/// Get a random value.
pub fn getRandom() u32 {
    return bindings.get_random();
}

test "getRandom returns values" {
    const a = getRandom();
    const b = getRandom();
    const c = getRandom();

    try std.testing.expectEqual(a + b + c, 12); // Stub always returns 4
}

/// Exit the app after the current update is finished.
pub fn quit() void {
    bindings.quit();
}

/// Get the peer corresponding to the local device.
pub fn getMe() Peer {
    const p = bindings.get_me();
    return Peer{ .id = @truncate(p) };
}

/// Get the list of peers online.
pub fn getPeers() Peers {
    return Peers{ .peers = bindings.get_peers() };
}

/// Save the [Stash](#ff.Stash)
pub fn saveStash(p: Peer, s: Stash) void {
    bindings.save_stash(p.id, @intFromPtr(s.ptr), s.len);
}

/// Load the [Stash](#ff.Stash), or `null`.
pub fn loadStash(p: Peer, s: Stash) ?Stash {
    const size = bindings.load_stash(p.id, @intFromPtr(s.ptr), s.len);
    if (size == 0) {
        return null;
    }
    return s[0..size];
}

/// Get the progress of earning the badge.
pub fn getProgress(p: Peer, b: Badge) Progress {
    return addProgress(p, b, 0);
}

/// Add the given value to the progress for the badge.
///
/// May be negative if you want to decrease the progress.
/// If zero, does not change the progress.
///
/// If the Peer is [`Peer.combined`], the progress is added to every peer
/// and the returned value is the lowest progress.
pub fn addProgress(p: Peer, b: Badge, val: i32) Progress {
    const raw: i32 = @intCast(bindings.add_progress(p.id, b, val));
    return Progress{
        .done = @intCast(@as(i16, @truncate(raw >> 16))),
        .goal = @intCast(@as(i16, @truncate(raw & 0xFFFF))),
    };
}

test "addProgress" {
    const actual = addProgress(.{ .id = 1 }, 2, 3);

    try std.testing.expectEqual(Progress{
        .done = 0,
        .goal = 4, // Stub always returns 4
    }, actual);
}

/// Get the personal best of the player.
pub fn getScore(p: Peer, b: Board) i16 {
    return addScore(p, b, 0);
}

/// Add the given score to the board.
///
/// May be negative if you want the lower scores
/// to rank higher. Zero value is not added to the board.
///
/// If the Peer is [`Peer.combined`], the score is added for every peer
/// and the returned value is the lowest of their best scores.
pub fn addScore(p: Peer, b: Board, val: i16) i16 {
    const raw = bindings.add_score(p.id, b, val);
    return @intCast(@as(i16, @truncate(raw & 0xFFFF)));
}
