module widgets

import ui
import os

pub const menubar_height = 30

const (
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

	file_dropdown_function := fn [open_sprite_file_function] (file_menu_item &ui.MenuItem) {
		change_file_dropdown_menu_visibility(file_menu_item, open_sprite_file_function)
	}

	return [
		ui.menubar(
			height: widgets.menubar_height
			z_index: widgets.menubar_z_index
			items: [
				ui.menuitem(
					text: widgets.menubar_file_button_text
					action: file_dropdown_function
				),
			]
		),
		ui.menu(
			id: widgets.file_dropdown_menu_id
			z_index: widgets.menubar_z_index
		),
	]
}

fn change_file_dropdown_menu_visibility(file_menu_item &ui.MenuItem, open_sprite_file_function fn (mut ui.MenuItem)) {
	mut file_dropdown_menu := file_menu_item.menu.ui.window.get[ui.Menu](widgets.file_dropdown_menu_id) or {
		panic('No file dropdown menu widget was found! This should have no place!')
	}

	// NOTE: this will be true only the first time when this menu will be shown.
	if file_dropdown_menu.get_items_count() == 0 {
		populate_file_dropdown_menu_with_buttons(mut file_dropdown_menu, open_sprite_file_function)
		file_dropdown_menu.hidden = false

		return
	}

	file_dropdown_menu.hidden = !file_dropdown_menu.hidden
}

fn populate_file_dropdown_menu_with_buttons(mut file_dropdown_menu ui.Menu, open_sprite_file_function fn (mut ui.MenuItem)) {
	file_dropdown_menu.add_item(
		text: widgets.open_sprite_file_button_text
		action: open_sprite_file_function
	)

	file_dropdown_menu.add_item(
		text: widgets.open_polygon_file_button_text
	)

	file_dropdown_menu.add_item(
		text: widgets.create_new_polygon_button_text
	)

	file_dropdown_menu.add_item(
		text: widgets.save_polygon_button_text
	)

	file_dropdown_menu.add_item(
		text: widgets.save_polygon_as_button_text
	)
}

fn open_sprite_file_dialog_with_kdialog() string {
	file_path_selection_result := os.execute("kdialog --getopenfilename . '*.png'")

	return file_path_selection_result.output.trim_indent()
}
