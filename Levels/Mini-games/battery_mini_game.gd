extends SubViewportContainer

@onready var playerNode = get_tree().get_first_node_in_group("Player")
@onready var batteryMiniGame = get_node(".")
@onready var parent = self.batteryMiniGame.get_parent().get_parent()
@onready var rootNode = $".."
@onready var button = $SubViewport/Button
@onready var batterySlot = $SubViewport/batterySlot
@onready var batterySpawn = $SubViewport/batterySpawn
@onready var battery = preload("res://Levels/Mini-games/Mini-game-mini-scenes/batteryPic.tscn").instantiate()
@onready var batteryslotEmpty = preload("res://Levels/Mini-games/Mini-game-mini-scenes/batterySlotEmpty.tscn").instantiate()
@onready var batteryslotArea = batteryslotEmpty.get_child(0)

@onready var solved = false
@onready var dragging = false

func _ready() -> void:
	rootNode.popup_hide.connect(_on_battery_mini_game_popup_hide)
	button.pressed.connect(_on_start_pressed)
	
	if playerNode.batteries != 0:
		batterySpawn.add_child(battery)
		battery.position = batterySpawn.position
		batterySlot.add_child(batteryslotEmpty)
		batteryslotEmpty.position = batterySlot.position

func _physics_process(delta: float) -> void:
		
		if solved == false:
			if Input.is_action_just_pressed("select"):
				var clickVector = get_local_mouse_position()
				if battery.position.distance_to(clickVector) < 20 :
					dragging = true
					print(dragging)
			if dragging == true:
				battery.position = get_local_mouse_position()
			if Input.is_action_just_released("select"):
				dragging = false
				if batteryslotArea.has_overlapping_areas():
					solved = true

func _on_start_pressed():
	if solved == true:
		GlobalSignals.batteryGameCompleted.emit(true)
		GlobalSignals.inMiniGame.emit(false)
		parent.solved = true
		rootNode.queue_free()

func _on_battery_mini_game_popup_hide() -> void:
	GlobalSignals.inMiniGame.emit(false)
	rootNode.queue_free()
