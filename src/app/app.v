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
	ui_app := App{
		window: setup_ui()
	}

	return ui_app.window
}

fn setup_ui() &ui.Window {
	return ui.window(
		width: app.window_width
		height: app.window_height
		title: app.window_title
		children: [
			ui.column(
				children: create_widgets()
			),
		]
	)
}

fn create_widgets() []ui.Widget {
	viewport_app := viewport.create_viewport_app()

	return [
		widgets.create_menubar_widget(viewport_app.open_work_sprite),
		viewport.create_viewport_widget(viewport_app),
	]
}
