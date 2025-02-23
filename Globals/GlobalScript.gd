extends Node

@onready var level = 0
@onready var numPuzzlesLeft = 0
@onready var numPuzzlesPerLevel = [2,0,7,0,13]
@onready var levelComplete = false
@onready var introComplete = false
@onready var levelStarted = false
@onready var mainMenu = true
@onready var inCutscene = true
@onready var gameWon = false


# Preload props so they can be instantiated later
@onready var map = "res://Levels/Ship/MainMap.tscn"


var prop_picker = [1,2,3]
var is_dragging = false
var time_limits = { 0: 20, 1: 60, 2: 20, 3: 180, 4: 20, 5: 360 }
var paused = false

func _ready() -> void:
	GlobalSignals.connect("DragNDropCompleted", _on_drag_game_completed)
	GlobalSignals.connect("wireGameCompleted", _on_wire_game_completed)
	GlobalSignals.connect("batteryGameCompleted", _on_battery_game_completed)
	GlobalSignals.connect("screenGameCompleted",_on_screen_game_completed)

func _physics_process(delta: float) -> void:
	
	if levelStarted == false and levelComplete == false and inCutscene == false:
		match level:
			0:
				numPuzzlesLeft = 0
			1: 
				numPuzzlesLeft = numPuzzlesPerLevel[0]
				levelStarted = true
			2:
				numPuzzlesLeft = 0
				inCutscene = true
				introComplete = false
				levelStarted = true
				load_next_level()
			3: 
				numPuzzlesLeft = numPuzzlesPerLevel[2]
				levelStarted = true
			4:
				numPuzzlesLeft = 0
				inCutscene = true
				introComplete = false
				levelStarted = true
				load_next_level()
			5: 
				numPuzzlesLeft = numPuzzlesPerLevel[4]
				levelStarted = true
				
	if numPuzzlesLeft == 0 and inCutscene == false:
		levelComplete = true
		
	if levelComplete == true and gameWon == false:
		level += 1
		levelComplete = false
		levelStarted = false
		load_next_level()

# Game complete functions
func _on_wire_game_completed(state : bool):
	numPuzzlesLeft -= 1
	print("Wire Game completed successfully")

func _on_battery_game_completed(state : bool):
	numPuzzlesLeft -= 1
	print("Battery Game completed successfully")
	
func _on_drag_game_completed(state : bool):
	numPuzzlesLeft -= 1
	print("DragNDrop Game completed successfully")

func _on_screen_game_completed(state : bool):
	numPuzzlesLeft -= 1
	print("Screen Game completed successfully")

func _start_level_one():
	pass
	
func load_next_level():
	if level > 5 and gameWon == false:
		gameWon = true
		get_tree().change_scene_to_file("res://Levels/Menus/Win.tscn")
		return
	print("Loading Level ", level)
	numPuzzlesLeft = numPuzzlesPerLevel[level - 1]
	if introComplete == true:
		get_tree().change_scene_to_file(map)
	else:
		get_tree().change_scene_to_file("res://CutScenes/IntroScene.tscn")

func get_time_for_level():
	return time_limits.get(level, 60)
	
