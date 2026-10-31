export fn add_menu_item() void {}

export fn add_progress() u32 {
    return 4;
}

export fn add_score() void {}
export fn clear_screen() void {}
export fn draw_arc() void {}
export fn draw_circle() void {}
export fn draw_ellipse() void {}
export fn draw_image() void {}
export fn draw_line() void {}
export fn draw_nine_slice() void {}
export fn draw_point() void {}
export fn draw_rect() void {}
export fn draw_rounded_rect() void {}
export fn draw_sector() void {}
export fn draw_sub_image() void {}
export fn draw_sub_tile() void {}
export fn draw_text() void {}
export fn draw_qr() void {}
export fn draw_triangle() void {}
export fn dump_file() void {}
export fn flip_x() void {}
export fn flip_y() void {}
export fn get_file_size() void {}
export fn get_me() void {}
export fn get_peers() void {}

export fn get_random() u32 {
    return 4;
}

export fn get_settings() u64 {
    // language "en", flags rotate|reduce_flashing,
    // theme id 7, bg/accent/secondary/primary = purple/red/orange/yellow
    return 0x4321070003656e;
}

export fn get_time() u64 {
    return 42;
}

export fn load_file() void {}
export fn load_stash() void {}
export fn log_debug() void {}
export fn log_error() void {}
export fn open_menu() void {}
export fn quit() void {}
export fn read_buttons() void {}
export fn read_pad() void {}
export fn remove_file() void {}
export fn remove_menu_item() void {}
export fn save_stash() void {}
export fn set_canvas() void {}
export fn set_color() void {}
export fn set_seed() void {}
export fn unset_canvas() void {}

// audio generators
export fn add_sine() u32 {
    return 0;
}
export fn add_square() u32 {
    return 0;
}
export fn add_sawtooth() u32 {
    return 0;
}
export fn add_triangle() u32 {
    return 0;
}
export fn add_noise() u32 {
    return 0;
}
export fn add_empty() u32 {
    return 0;
}
export fn add_zero() u32 {
    return 0;
}
export fn add_file() u32 {
    return 0;
}

// audio nodes
export fn add_mix() u32 {
    return 0;
}
export fn add_all_for_one() u32 {
    return 0;
}
export fn add_gain() u32 {
    return 0;
}
export fn add_loop() u32 {
    return 0;
}
export fn add_concat() u32 {
    return 0;
}
export fn add_pan() u32 {
    return 0;
}
export fn add_mute() u32 {
    return 0;
}
export fn add_pause() u32 {
    return 0;
}
export fn add_track_position() u32 {
    return 0;
}
export fn add_low_pass() u32 {
    return 0;
}
export fn add_high_pass() u32 {
    return 0;
}
export fn add_take_left() u32 {
    return 0;
}
export fn add_take_right() u32 {
    return 0;
}
export fn add_swap() u32 {
    return 0;
}
export fn add_clip() u32 {
    return 0;
}

// audio node control
export fn reset() void {}
export fn reset_all() void {}
export fn clear() void {}
export fn set_param() void {}

// audio modulators
export fn mod_linear() void {}
export fn mod_hold() void {}
export fn mod_sine() void {}
export fn mod_square() void {}
export fn mod_sawtooth() void {}
export fn mod_adsr() void {}
