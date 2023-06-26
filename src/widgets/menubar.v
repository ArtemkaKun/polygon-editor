module widgets

import ui

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
pub fn get_menubar_related_widgets() []ui.Widget {
	return [
		ui.menubar(
			height: widgets.menubar_height
			z_index: widgets.menubar_z_index
			items: [
				ui.menuitem(
					text: widgets.menubar_file_button_text
					action: change_file_dropdown_menu_visibility
				),
			]
		),
		ui.menu(
			id: widgets.file_dropdown_menu_id
			z_index: widgets.menubar_z_index
		),
	]
}

fn change_file_dropdown_menu_visibility(file_menu_item &ui.MenuItem) {
	mut file_dropdown_menu := file_menu_item.menu.ui.window.get[ui.Menu](widgets.file_dropdown_menu_id) or {
		panic('No file dropdown menu widget was found! This should have no place!')
	}

	// NOTE: this will be true only the first time when this menu will be shown.
	if file_dropdown_menu.get_items_count() == 0 {
		populate_file_dropdown_menu_with_buttons(mut file_dropdown_menu)
		file_dropdown_menu.hidden = false

		return
	}

	file_dropdown_menu.hidden = !file_dropdown_menu.hidden
}

fn populate_file_dropdown_menu_with_buttons(mut file_dropdown_menu ui.Menu) {
	file_dropdown_menu.add_item(
		text: widgets.open_sprite_file_button_text
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
