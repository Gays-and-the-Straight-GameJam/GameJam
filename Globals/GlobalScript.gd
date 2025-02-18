extends Node

@onready var level = 1
@onready var numPuzzlesLeft = 0
@onready var numPuzzlesPerLevel = [2,7,13]
@onready var levelComplete = false
@onready var introComplete = true
@onready var levelStarted = false

func _ready() -> void:
	GlobalSignals.connect("wireGameCompleted", _on_wire_game_completed)

func _physics_process(delta: float) -> void:
	
	if levelStarted == false:
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
	pass

# Game complete functions
func _on_wire_game_completed(state : bool):
	numPuzzlesLeft -= 1
	print("Wire Game completed successfully")
