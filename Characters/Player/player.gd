extends CharacterBody2D

@export var speed = 200
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var playerID = self.get_instance_id()
@onready var interactingWith = 0
@onready var inMiniGame = false
@onready var batteries = 0
@onready var level_timer: Timer = $"Level Timer"
@onready var timer_label: Label = $CanvasLayer/TimerLabel

var current_level: int = 1

var level_time_limits = {
	1: 60,
	2: 180,
	3: 360
}

enum  {Move}
var state = Move


func _ready() -> void:
	animation_tree.active = true
	update_timer_for_level()
	GlobalSignals.playerIDSignal.emit(playerID)
	GlobalSignals.objectIDSignal.connect(_object_interacted_with)
	GlobalSignals.inMiniGame.connect(_in_mini_game)
	GlobalSignals.batteryPickedUp.connect(_on_battery_pickup)
	
func _physics_process(delta: float) -> void:
	
	# State controller
	match state:
		Move:
			move_state()

	#Interact with something
	if Input.is_action_just_pressed("interact") and inMiniGame == false:
		GlobalSignals.interact.emit(true,interactingWith)
		GlobalSignals.batteryCount.emit(batteries)
	else:
		GlobalSignals.interact.emit(false,0)

func move_state():
	
	if inMiniGame == false:
		var input_direction = Input.get_vector("move_left","move_right","move_up","move_down")
		self.velocity = input_direction * speed
		if input_direction == Vector2.ZERO:
			animation_state.travel("Idle")
		else:
			animation_tree.set("parameters/Idle/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/Move/BlendSpace2D/blend_position", input_direction)
			animation_state.travel("Move")
		move_and_slide()

func _object_interacted_with(objectID : int):
	interactingWith = objectID

func _object_not_interacted_with():
	interactingWith = 0

func _in_mini_game(state : bool):
	inMiniGame = state

func _on_battery_pickup(state : bool):
	if state == true:
		self.batteries += 1
		GlobalSignals.batteryPickedUp.emit(false)

func _process(delta):
	timer_label.text = format_time(level_timer.time_left)

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "Time Left: %02d:%02d" % [minutes, secs]

func start_level_timer():
	if current_level in level_time_limits:
		level_timer.wait_time = level_time_limits[current_level]
		level_timer.start()

func _on_level_timer_timeout():
	timer_label.text = "00:00"
	print("Time is up! Loading Game Over screen...")
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Levels/Menus/OOT.tscn")
	
func update_timer_for_level():
	if level_timer:
		level_timer.stop()
		level_timer.wait_time = GlobalScript.get_time_for_level()
		level_timer.start()
		print("Timer set to:", level_timer.wait_time, "seconds for Level", GlobalScript.level)
