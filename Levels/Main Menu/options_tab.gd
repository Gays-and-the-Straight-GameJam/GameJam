extends Control

# Graphics
@onready var Fullscreen_btn = $TabContainer/Graphics/MarginContainer/VBoxContainer/Fullscreen_btn
@onready var WindowSize_btn = $TabContainer/Graphics/MarginContainer/VBoxContainer/WindowSize_btn
@onready var VSync_btn = $TabContainer/Graphics/MarginContainer/VBoxContainer/Vsync_btn

var options

func _ready() -> void:
	Save.load_settings()  # Load settings from file

	# **Fullscreen Toggle**
	Fullscreen_btn.set_pressed_no_signal(Save.config.get_value("video", "fullscreen", false))

	# **Window Size Dropdown**
	WindowSize_btn.clear()
	var screen_size = DisplayServer.screen_get_size()
	var selected_index = Save.get_resolution_index()

	for i in range(Save.window_size_list.size()):
		var win_size = Save.window_size_list[i]
		if win_size.width <= screen_size.x and win_size.height <= screen_size.y:
			WindowSize_btn.add_item(str(win_size.width) + " x " + str(win_size.height))
	
	if selected_index != -1:
		WindowSize_btn.select(selected_index)

	# **VSync Dropdown**
	VSync_btn.clear()
	var v_sync_index = Save.get_v_sync_index()

	for vsync in Save.v_sync_list:
		VSync_btn.add_item(vsync.label)

	if v_sync_index != -1:
		VSync_btn.select(v_sync_index)

	_load_keybindings_from_settings()
	_create_action_list()

func _load_keybindings_from_settings():
	var keybindings = Save.load_keybinding()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])

func _on_window_size_btn_item_selected(index: int) -> void:
	Save.set_resolution(index)  # Updated function call
	Save.resize_window()

func _on_vsync_btn_item_selected(index: int) -> void:
	Save.set_v_sync(index)  # Updated function call

func _on_fullscreen_btn_toggled(toggled_on: bool) -> void:
	Save.save_setting("video", "fullscreen", toggled_on)
	Save.resize_window()

# Keybinds
@onready var input_button_scene = preload("res://Levels/Main Menu/input_settings.tscn")
@onready var action_list = $TabContainer/Controls/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"move_up": "Move Up",
	"move_down": "Move Down",
	"move_left": "Move Left",
	"move_right": "Move Right",
	"interact": "Interact",
}

func _create_action_list():
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("Action")
		var input_label = button.find_child("Input")

		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""

		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("Input").text = "Press key to bind"

func _input(event) -> void:
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			Save.save_keybinding(action_to_remap, event)
			_update_action_list(remapping_button, event)

			is_remapping = false
			action_to_remap = null
			remapping_button = null
			accept_event()

func _update_action_list(button, event):
	button.find_child("Input").text = event.as_text().trim_suffix(" (Physical)")

func _on_reset_pressed() -> void:
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			Save.save_keybinding(action, events[0])
	_create_action_list()
