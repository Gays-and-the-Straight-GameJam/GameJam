
extends Control

@onready var start = $VBoxContainer/Start as Button
@onready var Options = $VBoxContainer/Options as Button
@onready var Quit = $VBoxContainer/Quit as Button
@export var Options_menu : String = "res://Levels/Menus/options_tab.tscn"
@export var level_1 : String = "res://Levels/Map.tscn"


func _ready() -> void:
	$VBoxContainer/Start.grab_focus()
	

func _on_start_pressed() -> void:
	Signals.MainMenu.emit(false)
	get_tree().change_scene_to_file(level_1)
	

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file(Options_menu)


func _on_quit_pressed() -> void:
	get_tree().quit()
	
