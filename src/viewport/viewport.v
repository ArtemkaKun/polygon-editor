module viewport

import gg
import ui
import ui.component { gg_canvaslayout }
import widgets

const viewport_z_index = 1

// ViewportApp is a `gg` app that represents a viewport for sprite rendering and polygon shape editing.
pub struct ViewportApp {
mut:
	gg                &gg.Context
	bounds            gg.Rect
	work_sprite       ?gg.Image
	app_window_height int
}

fn (mut app ViewportApp) on_init() {
	app.set_bounds(app.bounds)
}

fn (mut app ViewportApp) on_draw() {
	sprite_to_draw := app.work_sprite or { return }

	scale := 20
	sprite_width := sprite_to_draw.width * scale
	sprite_height := sprite_to_draw.height * scale

	viewport_center_x := app.bounds.x + app.bounds.width / 2
	viewport_center_y := app.bounds.y + app.bounds.height / 2

	sprite_x := viewport_center_x - sprite_width / 2
	sprite_y := viewport_center_y - sprite_height / 2

	app.gg.draw_image_by_id(sprite_x, sprite_y, sprite_width, sprite_height, sprite_to_draw.id)
}

fn (mut _ ViewportApp) on_delegate(_ &gg.Event) {}

fn (mut app ViewportApp) set_bounds(bb gg.Rect) {
	// HACK: since menubar submenus have a bug, we are using separate menu. This menu element influence viewport bounds for some reason,
	// but not influence it real position and size. This is probably another bug.
	// To overcome this problem, we a calculating size manually, this is simple since UI layout - this is just a menubar and viewport.
	// This hack probably provides problem for resizable window.
	app.bounds = gg.Rect{
		...bb
		height: app.app_window_height - widgets.menubar_height
	}
}

fn (mut app ViewportApp) run() {
	app.gg.run()
}

// create_viewport_widget creates viewport canvas widget for sprite rendering and polygon shape editing.
pub fn create_viewport_widget(viewport_app &ViewportApp) &ui.CanvasLayout {
	return gg_canvaslayout(
		app: viewport_app
		z_index: viewport.viewport_z_index
	)
}

// create_viewport_app creates a new `ViewportApp` instance and returns a reference to it.
pub fn create_viewport_app(app_window_height int) &ViewportApp {
	mut viewport_app := &ViewportApp{
		gg: unsafe { nil }
		app_window_height: app_window_height
	}

	viewport_app.gg = gg.new_context(
		user_data: viewport_app
		ui_mode: true
	)

	return viewport_app
}

// open_work_sprite opens a sprite from the provided path for editing in the viewport.
pub fn (mut app ViewportApp) open_work_sprite(path_to_sprite string) ! {
	app.work_sprite = app.gg.create_image(path_to_sprite)!
}
