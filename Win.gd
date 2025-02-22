extends Control



@onready var main_menu = $VBoxContainer/Main_menu as Button
@export var main_menu_scene: String = "res://Levels/Menus/main_menu.tscn"
@onready var exit_btn = $VBoxContainer/Exit_btn as Button


func _ready() -> void:
	main_menu.grab_focus()
	get_node("/root/MusicManager").play_music()
	main_menu.connect("pressed",_on_main_menu_pressed)
	exit_btn.connect("pressed",_on_exit_btn_pressed)

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
	

func _on_exit_btn_pressed() -> void:
	get_tree().quit()
