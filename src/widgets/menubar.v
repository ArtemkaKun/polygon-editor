module widgets

import ui
import os
import artemkakun.pcoll2d

const (
	menubar_height           = 30
	menubar_z_index          = 2
	menubar_file_button_text = 'File...'
)

// create_menubar_widget returns menubar widget.
pub fn create_menubar_widget(load_sprite_to_viewport_function fn (string) !, open_polygon_file fn (string) !, set_polygon_file_function fn (string), save_polygon fn ()) ui.Widget {
	return ui.menubar(
		height: widgets.menubar_height
		z_index: widgets.menubar_z_index
		items: [
			ui.menuitem(
				text: widgets.menubar_file_button_text
				submenu: create_file_menu(load_sprite_to_viewport_function, open_polygon_file,
					set_polygon_file_function, save_polygon)
			),
		]
	)
}

fn create_file_menu(load_sprite_to_viewport_function fn (string) !, open_polygon_file fn (string) !, set_polygon_file_function fn (string), save_polygon fn ()) &ui.Menu {
	open_sprite_file_function := fn [load_sprite_to_viewport_function] (_ &ui.MenuItem) {
		sprite_path := open_file_dialog_with_kdialog('.png')

		load_sprite_to_viewport_function(sprite_path) or {
			eprintln('Failed to load sprite file from path ${sprite_path}: ${err}')
		}
	}

	open_polygon_file_function := fn [open_polygon_file] (_ &ui.MenuItem) {
		polygon_path := open_file_dialog_with_kdialog('.json')

		open_polygon_file(polygon_path) or {
			eprintln('Failed to load polygon file from path ${polygon_path}: ${err}')
		}
	}

	create_polygon_file_function := fn [set_polygon_file_function] (_ &ui.MenuItem) {
		polygon_path := open_polygon_file_save_dialog_with_kdialog() or {
			eprintln('Error while selecting save path for new polygon file - ${err}')
			return
		}

		set_polygon_file_function(polygon_path)
	}

	save_polygon_function := fn [save_polygon] (_ &ui.MenuItem) {
		save_polygon()
	}

	file_menu_button_text_to_action_function_map := create_file_menu_button_text_to_action_function_map(open_sprite_file_function,
		open_polygon_file_function, create_polygon_file_function, save_polygon_function)

	file_menu_buttons := create_file_menu_buttons(file_menu_button_text_to_action_function_map)

	return ui.menu(
		z_index: widgets.menubar_z_index
		items: file_menu_buttons
	)
}

fn open_file_dialog_with_kdialog(file_extension string) string {
	file_path_selection_result := os.execute("kdialog --getopenfilename . '*${file_extension}'")

	return file_path_selection_result.output.trim_indent()
}

fn open_polygon_file_save_dialog_with_kdialog() !string {
	polygon_file_extension := pcoll2d.polygon_file_extension
	file_path_selection_result := os.execute("kdialog --getsavefilename . '*${polygon_file_extension}'")
	mut save_path := file_path_selection_result.output.trim_indent()

	if save_path == '' {
		return error('Empty save path')
	}

	if save_path.ends_with(polygon_file_extension) == false {
		save_path += polygon_file_extension
	}

	return save_path
}

fn create_file_menu_button_text_to_action_function_map(open_sprite_file_function fn (&ui.MenuItem), open_polygon_file_function fn (&ui.MenuItem), create_polygon_file_function fn (&ui.MenuItem), save_polygon_function fn (&ui.MenuItem)) map[string]fn (&ui.MenuItem) {
	unsafe {
		return {
			'Open sprite file':   open_sprite_file_function
			'Open polygon file':  open_polygon_file_function
			'Create new polygon': create_polygon_file_function
			'Save polygon':       save_polygon_function
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
