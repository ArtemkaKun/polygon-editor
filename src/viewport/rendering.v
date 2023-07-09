module viewport

import gg
import artemkakun.trnsfrm2d

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
	work_sprite_scale    = 20
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

	position, size := calculate_work_sprite_transforms(sprite_to_draw, app.bounds)

	app.gg.draw_image_by_id(f32(position.x), f32(position.y), f32(size.x), f32(size.y),
		sprite_to_draw.id)
}

fn calculate_work_sprite_transforms(work_sprite gg.Image, bounds gg.Rect) (trnsfrm2d.Position, trnsfrm2d.Vector) {
	sprite_width := work_sprite.width * viewport.work_sprite_scale
	sprite_height := work_sprite.height * viewport.work_sprite_scale

	viewport_center_x := bounds.x + bounds.width / 2
	viewport_center_y := bounds.y + bounds.height / 2

	sprite_x := viewport_center_x - sprite_width / 2
	sprite_y := viewport_center_y - sprite_height / 2

	return trnsfrm2d.Position{
		x: sprite_x
		y: sprite_y
	}, trnsfrm2d.Vector{
		x: sprite_width
		y: sprite_height
	}
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
