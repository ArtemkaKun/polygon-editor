module widgets

import ui
import os

const (
	menubar_height           = 30
	menubar_z_index          = 2
	menubar_file_button_text = 'File...'
	file_dropdown_menu_id    = 'file_menu_dropdown'
)

const (
	open_sprite_file_button_text   = 'Open sprite file'
	open_polygon_file_button_text  = 'Open polygon file'
	create_new_polygon_button_text = 'Create new polygon'
	save_polygon_button_text       = 'Save polygon'
	save_polygon_as_button_text    = 'Save polygon as...'
)

// get_menubar_related_widgets returns menubar related widgets (menubar and dropdown menu).
pub fn get_menubar_related_widgets(load_sprite_to_viewport_function fn (string) !) []ui.Widget {
	open_sprite_file_function := fn [load_sprite_to_viewport_function] (mut open_sprite_menu_item ui.MenuItem) {
		sprite_path := open_sprite_file_dialog_with_kdialog()

		load_sprite_to_viewport_function(sprite_path) or {
			eprintln('Failed to load sprite file from path ${sprite_path}: ${err}')
		}

		open_sprite_menu_item.menu.hidden = true
	}

	return [
		ui.menubar(
			height: widgets.menubar_height
			z_index: widgets.menubar_z_index
			items: [
				ui.menuitem(
					text: widgets.menubar_file_button_text
					submenu: ui.menu(
						id: widgets.file_dropdown_menu_id
						z_index: widgets.menubar_z_index
						items: [
							ui.menuitem(
								text: widgets.open_sprite_file_button_text
								action: open_sprite_file_function
							),
							ui.menuitem(
								text: widgets.open_polygon_file_button_text
							),
							ui.menuitem(
								text: widgets.create_new_polygon_button_text
							),
							ui.menuitem(
								text: widgets.save_polygon_button_text
							),
							ui.menuitem(
								text: widgets.save_polygon_as_button_text
							),
						]
					)
				),
			]
		),
	]
}

fn open_sprite_file_dialog_with_kdialog() string {
	file_path_selection_result := os.execute("kdialog --getopenfilename . '*.png'")

	return file_path_selection_result.output.trim_indent()
}
