extends SubViewportContainer

@onready var points = [
	Vector2(64,153),Vector2(85,125),Vector2(122,112),
	Vector2(152,93),Vector2(198,68),Vector2(240,50),
	Vector2(258,22),Vector2(26,85),Vector2(70,101),
	Vector2(148,125),Vector2(160,151),Vector2(200,103),
	Vector2(229,119),Vector2(249,155),Vector2(275,110),
	Vector2(81,20),Vector2(106,55),Vector2(132,83),
	Vector2(185,20),Vector2(169,49),Vector2(254,123),
	Vector2(173,84),Vector2(219,60),Vector2(50,97)
	]
@onready var solved = false
@onready var dragging = false
@onready var foam = preload("res://Levels/Mini-games/Mini-game-mini-scenes/foam.tscn")
@onready var subViewPort = $SubViewport
@onready var rootNode = $".."
@onready var screenMiniGame = get_node(".")
@onready var parent = self.screenMiniGame.get_parent().get_parent()
@onready var label = $SubViewport/Label

var mouse_position = Vector2(0,0)

func _ready() -> void:
	rootNode.popup_hide.connect(_on_screen_mini_game_popup_hide)
	label.text = "Total Spots Left: " + str(points.size())

func _physics_process(delta: float) -> void:
	

	
	if solved == false:
		if Input.is_action_just_pressed("select"):
			mouse_position = get_local_mouse_position()
			dragging = true
		elif Input.is_action_just_released("select"):
			dragging = false
		
		if dragging == true:
			mouse_position = get_local_mouse_position()
			for i in range(points.size()):
				if mouse_position.distance_to(points[i]) < 10:
					var foamInstance = foam.instantiate()
					subViewPort.add_child(foamInstance)
					foamInstance.position = points[i]
					print("Point fixed" + str(points[i]))
					points.pop_at(i)
					label.text = "Total Spots Left: " + str(points.size())
					break
				
	if points.is_empty():
		solved = true
		GlobalSignals.screenGameCompleted.emit(true)
		GlobalSignals.inMiniGame.emit(false)
		parent.solved = true
		rootNode.queue_free()

func _on_screen_mini_game_popup_hide() -> void:
	GlobalSignals.inMiniGame.emit(false)
	#rootNode.queue_free()
