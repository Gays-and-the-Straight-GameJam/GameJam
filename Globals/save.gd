extends CanvasLayer

var config = ConfigFile.new()
var current_monitor = DisplayServer.window_get_current_screen()
const SAVEFILE = "user://SAVEFILE.ini"

# Resolution Options
var window_size_list = [
	{"width": 2560, "height": 1440},
	{"width": 1920, "height": 1080},
	{"width": 1600, "height": 900},
	{"width": 1280, "height": 720},
]

# VSync Options
var v_sync_list = [
	{ "mode": DisplayServer.VSYNC_DISABLED, "label": "Vsync Disabled" },
	{ "mode": DisplayServer.VSYNC_ENABLED, "label": "Vsync Enabled" },
	{ "mode": DisplayServer.VSYNC_ADAPTIVE, "label": "Vsync Adaptive" },
]

func _ready() -> void:
	load_settings()  

# 
func save_setting(section: String, key: String, value):
	config.set_value(section, key, value)
	config.save(SAVEFILE)


func load_settings():
	if FileAccess.file_exists(SAVEFILE):
		config.load(SAVEFILE)
	else:
		
		config.set_value("video", "fullscreen", false)
		config.set_value("video", "v_sync", DisplayServer.VSYNC_ENABLED)
		config.set_value("video", "window_width", 1920)
		config.set_value("video", "window_height", 1080)
		config.save(SAVEFILE)


func set_resolution(index: int):
	if index >= 0 and index < window_size_list.size():
		var size = window_size_list[index]
		save_setting("video", "window_width", size.width)
		save_setting("video", "window_height", size.height)
		resize_window()


func set_v_sync(index: int):
	if index >= 0 and index < v_sync_list.size():
		var mode = v_sync_list[index].mode
		save_setting("video", "v_sync", mode)
		DisplayServer.window_set_vsync_mode(mode)


func resize_window():
	var screen_size = DisplayServer.screen_get_size()
	var width = config.get_value("video", "window_width", 1920)
	var height = config.get_value("video", "window_height", 1080)

	if config.get_value("video", "fullscreen", false):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_window().size = Vector2i(width, height)
		DisplayServer.window_set_position(Vector2i(
			(screen_size.x - width) / 2,
			(screen_size.y - height) / 2
		))
		DisplayServer.window_set_current_screen(current_monitor)


func get_resolution_index() -> int:
	var width = config.get_value("video", "window_width", 1920)
	var height = config.get_value("video", "window_height", 1080)

	for i in range(window_size_list.size()):
		if window_size_list[i].width == width and window_size_list[i].height == height:
			return i
	return -1  


func get_v_sync_index() -> int:
	var v_sync = config.get_value("video", "v_sync", DisplayServer.VSYNC_ENABLED)

	for i in range(v_sync_list.size()):
		if v_sync_list[i].mode == v_sync:
			return i
	return -1  

func save_keybinding(action: StringName, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)

	config.set_value("keybinding", action, event_str)
	config.save(SAVEFILE)


func load_keybinding():
	var keybindings = {}
	if config.has_section("keybinding"):
		for key in config.get_section_keys("keybinding"):
			var event_str = config.get_value("keybinding", key, "")
			var input_event

			if event_str.contains("mouse_"):
				input_event = InputEventMouseButton.new()
				input_event.button_index = int(event_str.split("_")[1])
			else:
				input_event = InputEventKey.new()
				input_event.keycode = OS.find_keycode_from_string(event_str)

			keybindings[key] = input_event
	return keybindings
	
