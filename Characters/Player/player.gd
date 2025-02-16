extends CharacterBody2D

@export var speed = 200
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

enum  {Move}
var state = Move
func _ready() -> void:
	animation_tree.active = true
	
func _physics_process(delta: float) -> void:
	
	# State controller
	match state:
		Move:
			move_state()


func move_state():
	
	var input_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	self.velocity = input_direction * speed
	if input_direction == Vector2.ZERO:
		animation_state.travel("Idle")
	else:
		animation_tree.set("parameters/Idle/BlendSpace2D/blend_position", input_direction)
		animation_tree.set("parameters/Move/BlendSpace2D/blend_position", input_direction)
		animation_state.travel("Move")
	move_and_slide()
