extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var map = "res://Levels/Ship/MainMap.tscn"
@onready var intern = $Intern

func _ready() -> void:
	if GlobalScript.level == 0:
		animation_player.play("introScene")
	elif GlobalScript.level == 2:
		animation_player.play("level2")
	elif GlobalScript.level == 4:
		animation_player.play("level3")
	pass
	
func _scene_finished():
	GlobalScript.introComplete = true
	GlobalScript.inCutscene = false
