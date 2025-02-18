extends CharacterBody2D


@export var walk_speed = 50.0  # Speed of the NPC
@export var walk_area: Rect2 = Rect2(-100, -100, 200, 200)  # Area the NPC can walk within
@export var min_walk_time = 1.0  # Minimum time to walk in one direction
@export var max_walk_time = 3.0  # Maximum time to walk in one direction
@export var min_stop_time = 1.0  # Minimum time to stop
@export var max_stop_time = 3.0  # Maximum time to stop
@export var activation_range = 300.0  # Range within which the player activates the NPC


var target_position: Vector2  
var is_walking: bool = false  
var timer = 0.0 
var player: Node2D 

@onready var animation_tree: AnimationTree = $AnimationTree  
@onready var animation_state = animation_tree["parameters/playback"] 

func _ready():
	
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		print("Player not found! Ensure the player is in the 'Player' group.")
		set_process(false)

func _process(delta):
	if not player:
		return

	
	if global_position.distance_to(player.global_position) > activation_range:
		
		velocity = Vector2.ZERO
		animation_state.travel("Idle") 
		return

	
	timer -= delta
	if timer <= 0:
		if is_walking:
			
			is_walking = false
			timer = randf_range(min_stop_time, max_stop_time)
			velocity = Vector2.ZERO
			animation_state.travel("Idle")  
		else:
			
			is_walking = true
			timer = randf_range(min_walk_time, max_walk_time)
			target_position = _get_random_position_within_area()
			var direction = (target_position - global_position).normalized()
			velocity = direction * walk_speed

			
			animation_tree.set("parameters/Idle/BlendSpace2D/blend_position", direction)
			animation_tree.set("parameters/Move/BlendSpace2D/blend_position", direction)
			animation_state.travel("Move")

	
	move_and_slide()

func _get_random_position_within_area() -> Vector2:
	
	return Vector2(
		randf_range(walk_area.position.x, walk_area.position.x + walk_area.size.x),
		randf_range(walk_area.position.y, walk_area.position.y + walk_area.size.y)
	) + global_position
