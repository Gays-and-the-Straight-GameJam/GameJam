extends Node

@onready var level = 1
@onready var numPuzzlesLeft = 0
@onready var numPuzzlesPerLevel = [2,7,13]
@onready var levelComplete = false
@onready var introComplete = true
@onready var levelStarted = false
@onready var mainMenu = true
@onready var inCutscene = true


# Preload props so they can be instantiated later
@onready var Controlpanel = preload("res://Levels/Props/ControlPanel.tscn")
@onready var fuseProp = preload("res://Levels/Props/fuseProp.tscn")
var prop_picker = [1,2,3]
var is_dragging = false
var time_limits = { 1: 60, 2: 180, 3: 360 }
var paused = false

func _ready() -> void:
	GlobalSignals.connect("DragNDropCompleted", _on_drag_game_completed)
	GlobalSignals.connect("wireGameCompleted", _on_wire_game_completed)
	GlobalSignals.connect("batteryGameCompleted", _on_battery_game_completed)
	GlobalSignals.connect("screenGameCompleted",_on_screen_game_completed)

func _physics_process(delta: float) -> void:
	
	if levelStarted == false and levelComplete == false:
		match level:
			0:
				numPuzzlesLeft = 0
			1: 
				numPuzzlesLeft = numPuzzlesPerLevel[0]
				levelStarted = true
			2: 
				numPuzzlesLeft = numPuzzlesPerLevel[1]
				levelStarted = true
			3: 
				numPuzzlesLeft = numPuzzlesPerLevel[2]
				levelStarted = true
				
	if numPuzzlesLeft == 0:
		levelComplete = true
		
	if levelComplete == true:
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
	if level > 3:
		get_tree().change_scene_to_file("res://Levels/Menus/Win.tscn")
		return
	print("Loading Level ", level)
	numPuzzlesLeft = numPuzzlesPerLevel[level - 1]
	get_tree().reload_current_scene()

func get_time_for_level():
	return time_limits.get(level, 60)
	
