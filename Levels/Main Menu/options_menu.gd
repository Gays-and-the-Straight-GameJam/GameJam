
extends Control

@export var Main_Menu : String = "res://Levels/main_menu.tscn"


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file(Main_Menu)
