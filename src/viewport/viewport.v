module viewport

import gg
import ui
import ui.component { gg_canvaslayout }

const viewport_z_index = 1

// ViewportApp is a `gg` app that represents a viewport for sprite rendering and polygon shape editing.
pub struct ViewportApp {
mut:
	gg     &gg.Context
	bounds gg.Rect
}

fn (mut app ViewportApp) on_init() {
	app.set_bounds(app.bounds)
}

fn (mut _ ViewportApp) on_draw() {}

fn (mut _ ViewportApp) on_delegate(_ &gg.Event) {}

fn (mut app ViewportApp) set_bounds(bb gg.Rect) {
	app.bounds = bb
}

fn (mut app ViewportApp) run() {
	app.gg.run()
}

// create_viewport_widget creates viewport canvas widget for sprite rendering and polygon shape editing.
pub fn create_viewport_widget() &ui.CanvasLayout {
	return gg_canvaslayout(
		app: create_viewport_app()
		z_index: viewport.viewport_z_index
	)
}

fn create_viewport_app() &ViewportApp {
	mut viewport_app := &ViewportApp{
		gg: unsafe { nil }
	}

	viewport_app.gg = gg.new_context(
		user_data: viewport_app
		ui_mode: true
	)

	return viewport_app
}
