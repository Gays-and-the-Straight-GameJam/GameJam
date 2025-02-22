
extends Control

@onready var start = $VBoxContainer/Start as Button
@onready var Options = $VBoxContainer/Options as Button
@onready var Quit = $VBoxContainer/Quit as Button
@onready var menu_music = $AudioStreamPlayer
@export var Options_menu : String = "res://Levels/Menus/options_tab.tscn"
@export var level_1 : String = "res://Levels/Map.tscn"
@onready var animated_texture = preload("res://Assets/Props/AnimatedBackground.tres")
 

func _ready() -> void:
	$VBoxContainer/Start.grab_focus()
	get_node("/root/MusicManager").play_music()
	$TextureRect.texture = animated_texture

func _on_start_pressed() -> void:
	Signals.MainMenu.emit(false)
	MusicManager.stop_music()
	get_tree().change_scene_to_file(level_1)
	

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file(Options_menu)


func _on_quit_pressed() -> void:
	get_tree().quit()
	
