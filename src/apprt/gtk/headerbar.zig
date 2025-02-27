const std = @import("std");
const c = @import("c.zig").c;

const Window = @import("Window.zig");
const adwaita = @import("adwaita.zig");

const AdwHeaderBar = if (adwaita.versionAtLeast(0, 0, 0)) c.AdwHeaderBar else void;

pub const HeaderBar = union(enum) {
    adw: *AdwHeaderBar,
    gtk: *c.GtkHeaderBar,

    pub fn init(window: *Window) HeaderBar {
        if ((comptime adwaita.versionAtLeast(1, 4, 0)) and
            adwaita.enabled(&window.app.config))
        {
            return initAdw();
        }

        return initGtk();
    }

    fn initAdw() HeaderBar {
        const headerbar = c.adw_header_bar_new();
        return .{ .adw = @ptrCast(headerbar) };
    }

    fn initGtk() HeaderBar {
        const headerbar = c.gtk_header_bar_new();
        return .{ .gtk = @ptrCast(headerbar) };
    }

    pub fn asWidget(self: HeaderBar) *c.GtkWidget {
        return switch (self) {
            .adw => |headerbar| @ptrCast(@alignCast(headerbar)),
            .gtk => |headerbar| @ptrCast(@alignCast(headerbar)),
        };
    }

    pub fn packEnd(self: HeaderBar, widget: *c.GtkWidget) void {
        switch (self) {
            .adw => |headerbar| if (comptime adwaita.versionAtLeast(0, 0, 0)) {
                c.adw_header_bar_pack_end(
                    @ptrCast(@alignCast(headerbar)),
                    widget,
                );
            },
            .gtk => |headerbar| c.gtk_header_bar_pack_end(
                @ptrCast(@alignCast(headerbar)),
                widget,
            ),
        }
    }

    pub fn packStart(self: HeaderBar, widget: *c.GtkWidget) void {
        switch (self) {
            .adw => |headerbar| if (comptime adwaita.versionAtLeast(0, 0, 0)) {
                c.adw_header_bar_pack_start(
                    @ptrCast(@alignCast(headerbar)),
                    widget,
                );
            },
            .gtk => |headerbar| c.gtk_header_bar_pack_start(
                @ptrCast(@alignCast(headerbar)),
                widget,
            ),
        }
    }
};
