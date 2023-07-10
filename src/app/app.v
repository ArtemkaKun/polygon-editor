module app

import ui
import viewport
import widgets

const (
	window_width  = 600
	window_height = window_width
	window_title  = 'Polygon Editor'
)

[heap]
struct App {
mut:
	window      &ui.Window
	status_text string
}

// create_app creates a new UI app and returns its windows.
pub fn create_app() &ui.Window {
	mut ui_app := &App{
		window: unsafe { nil }
		status_text: ''
	}

	setup_ui(mut ui_app)

	return ui_app.window
}

fn setup_ui(mut ui_app App) {
	ui_app.window = ui.window(
		width: app.window_width
		height: app.window_height
		title: app.window_title
		children: [
			ui.column(
				children: create_widgets(mut ui_app)
			),
		]
	)
}

fn create_widgets(mut app App) []ui.Widget {
	viewport_app := viewport.create_viewport_app()

	return [
		widgets.create_menubar_widget(viewport_app.open_work_sprite, viewport_app.open_polygon,
			viewport_app.create_polygon_file, viewport_app.save_polygon, app.set_status_text),
		viewport.create_viewport_widget(viewport_app),
		ui.textbox(height: 30, read_only: true, z_index: 2, text: &app.status_text, text_size: 26),
	]
}

fn (mut app App) set_status_text(text string) {
	app.status_text = text
}
