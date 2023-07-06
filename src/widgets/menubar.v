module widgets

import ui
import os

const (
	menubar_height           = 30
	menubar_z_index          = 2
	menubar_file_button_text = 'File...'
)

// create_menubar_widget returns menubar widget.
pub fn create_menubar_widget(load_sprite_to_viewport_function fn (string) !, set_polygon_file_function fn (string)) ui.Widget {
	return ui.menubar(
		height: widgets.menubar_height
		z_index: widgets.menubar_z_index
		items: [
			ui.menuitem(
				text: widgets.menubar_file_button_text
				submenu: create_file_menu(load_sprite_to_viewport_function, set_polygon_file_function)
			),
		]
	)
}

fn create_file_menu(load_sprite_to_viewport_function fn (string) !, set_polygon_file_function fn (string)) &ui.Menu {
	open_sprite_file_function := fn [load_sprite_to_viewport_function] (_ &ui.MenuItem) {
		sprite_path := open_sprite_file_dialog_with_kdialog()

		load_sprite_to_viewport_function(sprite_path) or {
			eprintln('Failed to load sprite file from path ${sprite_path}: ${err}')
		}
	}

	create_polygon_file_function := fn [set_polygon_file_function] (_ &ui.MenuItem) {
		polygon_path := open_polygon_file_save_dialog_with_kdialog() or {
			eprintln('Error while selecting save path for new polygon file - ${err}')
			return
		}

		set_polygon_file_function(polygon_path)
	}

	file_menu_button_text_to_action_function_map := create_file_menu_button_text_to_action_function_map(open_sprite_file_function,
		create_polygon_file_function)

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

fn open_polygon_file_save_dialog_with_kdialog() !string {
	file_path_selection_result := os.execute("kdialog --getsavefilename . '*.json'")
	mut save_path := file_path_selection_result.output.trim_indent()

	if save_path == '' {
		return error('Empty save path')
	}

	if save_path.ends_with('.json') == false {
		save_path += '.json'
	}

	return save_path
}

fn create_file_menu_button_text_to_action_function_map(open_sprite_file_function fn (&ui.MenuItem), create_polygon_file_function fn (&ui.MenuItem)) map[string]fn (&ui.MenuItem) {
	unsafe {
		return {
			'Open sprite file':   open_sprite_file_function
			'Open polygon file':  nil
			'Create new polygon': create_polygon_file_function
			'Save polygon':       nil
			'Save polygon as...': nil
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
