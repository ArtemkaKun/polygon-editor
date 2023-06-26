module app

import ui
import viewport
import widgets

const (
	window_width  = 600
	window_height = window_width
	window_title  = 'Polygon Editor'
)

struct App {
mut:
	window &ui.Window
}

// create_app creates a new UI app and returns its windows.
pub fn create_app() &ui.Window {
	mut ui_app := App{
		window: unsafe { nil }
	}

	setup_ui(mut ui_app)

	return ui_app.window
}

fn setup_ui(mut ui_app App) {
	mut ui_widgets := []ui.Widget{}
	ui_widgets << widgets.get_menubar_related_widgets()
	ui_widgets << viewport.create_viewport_widget()

	ui_app.window = ui.window(
		width: app.window_width
		height: app.window_height
		title: app.window_title
		children: [
			ui.column(
				children: ui_widgets
			),
		]
	)
}
