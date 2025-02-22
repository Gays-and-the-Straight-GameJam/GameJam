
extends Control

@onready var start = $VBoxContainer/Start as Button
@onready var Options = $VBoxContainer/Options as Button
@onready var Quit = $VBoxContainer/Quit as Button
@onready var menu_music = $AudioStreamPlayer
@export var Options_menu : String = "res://Levels/Menus/options_tab.tscn"
@export var intro : String = "res://CutScenes/IntroScene.tscn"


func _ready() -> void:
	$VBoxContainer/Start.grab_focus()
	MusicManager.play_music("res://Assets/Music/Main_menu_theme.wav")
	

func _on_start_pressed() -> void:
	Signals.MainMenu.emit(false)
	MusicManager.stop_music()
	get_tree().change_scene_to_file(intro)
	

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file(Options_menu)


func _on_quit_pressed() -> void:
	get_tree().quit()
	
