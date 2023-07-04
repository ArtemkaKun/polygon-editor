module viewport

import gg
import ui
import ui.component { gg_canvaslayout }
import artemkakun.trnsfrm2d

const viewport_z_index = 1

const (
	background_color = gg.Color{
		r: 211
		g: 211
		b: 211
	}

	connection_draw_parameters = gg.PenConfig{
		color: gg.Color{
			r: 0
			g: 139
			b: 139
		}
		thickness: 2
	}

	polygon_point_color = gg.Color{
		r: 0
		g: 255
		b: 255
	}

	polygon_point_radius = 5
)

const mouse_button_to_action_function_map = {
	gg.MouseButton.left:  handle_mouse_left_click
	gg.MouseButton.right: remove_point
}

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
	// NOTE: order matters! Last drawn element will be on top of all others.
	draw_viewport_background(mut app)
	draw_work_sprite(mut app)
	draw_polygon_connections(mut app)
	draw_polygon_points(mut app)
}

fn draw_viewport_background(mut app ViewportApp) {
	app.gg.draw_rect_filled(app.bounds.x, app.bounds.y, app.bounds.width, app.bounds.height,
		viewport.background_color)
}

fn draw_work_sprite(mut app ViewportApp) {
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

fn draw_polygon_connections(mut app ViewportApp) {
	for point_index, point_position in app.polygon_points {
		next_point_index := if point_index == app.polygon_points.len - 1 {
			0
		} else {
			point_index + 1
		}

		next_point_position := app.polygon_points[next_point_index]

		app.gg.draw_line_with_config(f32(point_position.x), f32(point_position.y), f32(next_point_position.x),
			f32(next_point_position.y), viewport.connection_draw_parameters)
	}
}

fn draw_polygon_points(mut app ViewportApp) {
	for point_position in app.polygon_points {
		app.gg.draw_circle_filled(f32(point_position.x), f32(point_position.y), viewport.polygon_point_radius,
			viewport.polygon_point_color)
	}
}

fn (mut app ViewportApp) on_delegate(event &gg.Event) {
	if app.polygon_file_path == none {
		return
	}

	if event.typ == .mouse_down {
		mouse_button_to_action_function_map[event.mouse_button](mut app, event)
	} else if event.typ == .mouse_up {
		if event.mouse_button == .left {
			app.selected_point_id = none
		}
	} else if event.typ == .mouse_move {
		if app.selected_point_id != none {
			point_to_move_id := app.selected_point_id or { return }

			app.polygon_points[point_to_move_id] = trnsfrm2d.Position{
				x: event.mouse_x
				y: event.mouse_y
			}
		}
	}
}

fn handle_mouse_left_click(mut app ViewportApp, event &gg.Event) {
	new_point_position := trnsfrm2d.Position{
		x: event.mouse_x
		y: event.mouse_y
	}

	selected_point := app.polygon_points.filter(trnsfrm2d.calculate_distance_between_vectors(it.Vector,
		new_point_position.Vector) <= viewport.polygon_point_radius)

	if selected_point.len == 1 {
		app.selected_point_id = app.polygon_points.index(selected_point[0])
	} else {
		add_point(mut app, event)
	}
}

fn add_point(mut app ViewportApp, event &gg.Event) {
	new_point_position := trnsfrm2d.Position{
		x: event.mouse_x
		y: event.mouse_y
	}

	if app.polygon_points.any(trnsfrm2d.calculate_distance_between_vectors(it.Vector,
		new_point_position.Vector) <= viewport.polygon_point_radius * 2)
	{
		return
	}

	app.polygon_points << new_point_position
}

fn remove_point(mut app ViewportApp, event &gg.Event) {
	for point_index, point_position in app.polygon_points {
		distance_between_mouse_and_point := trnsfrm2d.calculate_distance_between_vectors(point_position.Vector,
			trnsfrm2d.Vector{event.mouse_x, event.mouse_y})

		if distance_between_mouse_and_point <= viewport.polygon_point_radius {
			app.polygon_points.delete(point_index)
			break
		}
	}
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
