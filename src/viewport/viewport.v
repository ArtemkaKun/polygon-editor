module viewport

import gg
import ui
import ui.component { gg_canvaslayout }
import artemkakun.trnsfrm2d
import os
import x.json2
import artemkakun.pcoll2d
import json

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
	if app.polygon_file_path == none || app.work_sprite == none {
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

// open_polygon opens a polygon shape from the provided path for editing in the viewport.
pub fn (mut app ViewportApp) open_polygon(path_to_polygon string) ! {
	polygon_data := os.read_file(path_to_polygon)!
	polygon := json.decode(pcoll2d.Polygon, polygon_data)!
	position := get_work_sprite_position(app)!

	mut global_polygon_points := []trnsfrm2d.Position{}

	for point in polygon.points {
		global_polygon_points << trnsfrm2d.Position{
			x: point.x * work_sprite_scale + position.x
			y: point.y * work_sprite_scale + position.y
		}
	}

	app.polygon_points = global_polygon_points
	app.set_polygon_file_path(path_to_polygon)
}

// create_polygon_file deletes existing polygon points and sets the path to the polygon file that will be used for editing in the viewport.
pub fn (mut app ViewportApp) create_polygon_file(path_to_polygon string) {
	app.polygon_points = []
	app.set_polygon_file_path(path_to_polygon)
}

// set_polygon_file_path sets the path to the polygon file that will be used for editing in the viewport.
fn (mut app ViewportApp) set_polygon_file_path(path_to_polygon string) {
	app.polygon_file_path = path_to_polygon
}

// save_polygon saves the polygon shape to the file that was set with `set_polygon_file_path`.
pub fn (app &ViewportApp) save_polygon() {
	polygon_save_path := app.polygon_file_path or { return }
	polygon_in_json_form := create_polygon_data_in_json_form(app) or { return }

	os.write_file(polygon_save_path, polygon_in_json_form) or {
		println('Failed to save polygon to file ${polygon_save_path}: ${err}')
	}
}

fn create_polygon_data_in_json_form(app ViewportApp) !string {
	position := get_work_sprite_position(app)!
	mut local_polygon_points := []trnsfrm2d.Position{}

	for global_polygon_point in app.polygon_points {
		local_polygon_points << trnsfrm2d.Position{
			x: (global_polygon_point.x - position.x) / work_sprite_scale
			y: (global_polygon_point.y - position.y) / work_sprite_scale
		}
	}

	polygon := pcoll2d.Polygon{local_polygon_points}
	return json2.encode[pcoll2d.Polygon](polygon)
}

fn get_work_sprite_position(app ViewportApp) !trnsfrm2d.Position {
	sprite_to_draw := app.work_sprite or { return error('No work sprite!') }

	position, _ := calculate_work_sprite_transforms(sprite_to_draw, app.bounds)

	return position
}
