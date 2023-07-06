module viewport

import gg
import ui
import ui.component { gg_canvaslayout }
import artemkakun.trnsfrm2d

const viewport_z_index = 1

// ViewportApp is a `gg` app that represents a viewport for sprite rendering and polygon shape editing.
pub struct ViewportApp {
mut:
	gg                &gg.Context
	bounds            gg.Rect
	work_sprite       ?gg.Image
	polygon_points    []trnsfrm2d.Position
	polygon_file_path ?string
	selected_point_id ?int
}

fn (mut app ViewportApp) on_init() {
	app.set_bounds(app.bounds)
}

fn (mut app ViewportApp) on_draw() {
	render_viewport(mut app)
}

fn (mut app ViewportApp) on_delegate(event &gg.Event) {
	if app.polygon_file_path == none {
		return
	}

	handle_user_input(mut app, event)
}

fn (mut app ViewportApp) set_bounds(bb gg.Rect) {
	app.bounds = bb
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
pub fn create_viewport_app() &ViewportApp {
	mut viewport_app := &ViewportApp{
		gg: unsafe { nil }
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

// set_polygon_file_path sets the path to the polygon file that will be used for editing in the viewport.
pub fn (mut app ViewportApp) set_polygon_file_path(path_to_polygon string) {
	app.polygon_file_path = path_to_polygon
}
