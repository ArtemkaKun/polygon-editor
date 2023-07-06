module viewport

import gg

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

fn render_viewport(mut app ViewportApp) {
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
