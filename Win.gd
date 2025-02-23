extends Control



@onready var main_menu = $VBoxContainer/Main_menu as Button
@export var main_menu_scene: String = "res://Levels/Menus/main_menu.tscn"
@onready var exit_btn = $VBoxContainer/Exit_btn as Button
@onready var animated_texture = preload("res://Assets/Props/AnimatedBackground.tres")
@onready var credits_btn = $VBoxContainer/Credits as Button


func _ready() -> void:
	GlobalScript.level = 0
	GlobalScript.levelComplete = false
	GlobalScript.introComplete = false
	GlobalScript.levelStarted = false
	GlobalScript.mainMenu = true
	GlobalScript.gameWon = false
	GlobalScript.inCutscene = true
	main_menu.grab_focus()
	get_node("/root/MusicManager").play_music()
	main_menu.connect("pressed",_on_main_menu_pressed)
	exit_btn.connect("pressed",_on_exit_btn_pressed)
	credits_btn.connect("pressed",_on_credits_pressed)
	$TextureRect.texture = animated_texture

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
	

func _on_exit_btn_pressed() -> void:
	get_tree().quit()



func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Menus/GodotCredits.tscn")
