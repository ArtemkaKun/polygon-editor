module viewport

import artemkakun.trnsfrm2d
import gg
import sokol.sapp

const mouse_action_to_function_map = {
	sapp.EventType.mouse_down: handle_mouse_down_signal
	sapp.EventType.mouse_up:   handle_mouse_up_signal
	sapp.EventType.mouse_move: handle_mouse_move_signal
}

const mouse_down_button_to_action_function_map = {
	gg.MouseButton.left:  handle_mouse_left_click
	gg.MouseButton.right: remove_point
}

fn handle_user_input(mut app ViewportApp, event &gg.Event) {
	if event.typ !in viewport.mouse_action_to_function_map {
		return
	}

	mouse_action_to_function_map[event.typ](mut app, event)
}

fn handle_mouse_down_signal(mut app ViewportApp, event &gg.Event) {
	mouse_down_button_to_action_function_map[event.mouse_button](mut app, event)
}

fn handle_mouse_up_signal(mut app ViewportApp, event &gg.Event) {
	if event.mouse_button == .left {
		app.selected_point_id = none
	}
}

fn handle_mouse_move_signal(mut app ViewportApp, event &gg.Event) {
	if app.selected_point_id != none {
		point_to_move_id := app.selected_point_id or { return }

		app.polygon_points[point_to_move_id] = get_mouse_position(event)
	}
}

fn handle_mouse_left_click(mut app ViewportApp, event &gg.Event) {
	new_point_position := get_mouse_position(event)

	selected_point := app.polygon_points.filter(trnsfrm2d.calculate_distance_between_positions(it,
		new_point_position) <= polygon_point_radius)

	if selected_point.len == 1 {
		app.selected_point_id = app.polygon_points.index(selected_point[0])
	} else {
		add_point(mut app, new_point_position)
	}
}

fn add_point(mut app ViewportApp, new_point_position trnsfrm2d.Position) {
	if app.polygon_points.any(trnsfrm2d.calculate_distance_between_positions(it, new_point_position) <= polygon_point_radius * 2) {
		return
	}

	app.polygon_points << new_point_position
}

fn remove_point(mut app ViewportApp, event &gg.Event) {
	for point_index, point_position in app.polygon_points {
		distance_between_mouse_and_point := trnsfrm2d.calculate_distance_between_positions(point_position,
			get_mouse_position(event))

		if distance_between_mouse_and_point <= polygon_point_radius {
			app.polygon_points.delete(point_index)
			break
		}
	}
}

fn get_mouse_position(event &gg.Event) trnsfrm2d.Position {
	return trnsfrm2d.Position{
		x: event.mouse_x
		y: event.mouse_y
	}
}
