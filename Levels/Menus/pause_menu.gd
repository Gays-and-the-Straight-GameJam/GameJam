extends Control

@onready var main = $"../.."
@onready var Resume_btn = $VBoxContainer/Resume
@onready var Settings_btn = $VBoxContainer/Settings
@onready var Exit_btn = $VBoxContainer/Exit




func _on_resume_pressed() -> void:
	GlobalScript.paused = false
	main.pauseMenu()


func _on_restart_pressed() -> void:
	GlobalScript.paused = false
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Menus/main_menu.tscn")
