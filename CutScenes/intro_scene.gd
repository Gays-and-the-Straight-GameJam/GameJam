extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var map = "res://Levels/Ship/MainMap.tscn"
@onready var intern = $Intern

func _ready() -> void:
	animation_player.play("introScene")
	pass
	
func _scene_finished():
	get_tree().change_scene_to_file(map)
	GlobalScript.introComplete = true
	GlobalScript.inCutscene = false
	intern.queue_free()
