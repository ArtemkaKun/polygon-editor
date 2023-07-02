module widgets

import ui
import os

const (
	menubar_height           = 30
	menubar_z_index          = 2
	menubar_file_button_text = 'File...'
)

const file_menu_buttons_text = [
	'Open sprite file',
	'Open polygon file',
	'Create new polygon',
	'Save polygon',
	'Save polygon as...',
]

// create_menubar_widget returns menubar widget.
pub fn create_menubar_widget(load_sprite_to_viewport_function fn (string) !) ui.Widget {
	return ui.menubar(
		height: widgets.menubar_height
		z_index: widgets.menubar_z_index
		items: [
			ui.menuitem(
				text: widgets.menubar_file_button_text
				submenu: create_file_menu(load_sprite_to_viewport_function)
			),
		]
	)
}

fn create_file_menu(load_sprite_to_viewport_function fn (string) !) &ui.Menu {
	open_sprite_file_function := fn [load_sprite_to_viewport_function] (_ &ui.MenuItem) {
		sprite_path := open_sprite_file_dialog_with_kdialog()

		load_sprite_to_viewport_function(sprite_path) or {
			eprintln('Failed to load sprite file from path ${sprite_path}: ${err}')
		}
	}

	file_menu_button_text_to_action_function_map := create_file_menu_button_text_to_action_function_map(open_sprite_file_function)
	file_menu_buttons := create_file_menu_buttons(file_menu_button_text_to_action_function_map)

	return ui.menu(
		z_index: widgets.menubar_z_index
		items: file_menu_buttons
	)
}

fn open_sprite_file_dialog_with_kdialog() string {
	file_path_selection_result := os.execute("kdialog --getopenfilename . '*.png'")

	return file_path_selection_result.output.trim_indent()
}

fn create_file_menu_button_text_to_action_function_map(open_sprite_file_function fn (&ui.MenuItem)) map[string]fn (&ui.MenuItem) {
	unsafe {
		return {
			widgets.file_menu_buttons_text[0]: open_sprite_file_function
			widgets.file_menu_buttons_text[1]: nil
			widgets.file_menu_buttons_text[2]: nil
			widgets.file_menu_buttons_text[3]: nil
			widgets.file_menu_buttons_text[4]: nil
		}
	}
}

fn create_file_menu_buttons(file_menu_button_text_to_action_function_map map[string]fn (&ui.MenuItem)) []&ui.MenuItem {
	mut file_menu_buttons := []&ui.MenuItem{}

	for text, action_function in file_menu_button_text_to_action_function_map {
		file_menu_buttons << ui.menuitem(
			text: text
			action: action_function
		)
	}

	return file_menu_buttons
}
