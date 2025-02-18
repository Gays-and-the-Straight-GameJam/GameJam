extends CharacterBody2D

@export var Speed: int = 150
@export var radiuslimit = 50

@onready var animTree = $AnimationTree
@onready var closestEntity = $ClosestEntity
@onready var playerCollision = $PlayerCollision

var knockback_dir = Vector2.ZERO
var knockback = Vector2.ZERO
var mov_direction = Vector2()
var radius_squared = radiuslimit**2
var radius_squared_enemy = 40**2
var isfollowing = true

enum FollowerState{
	IDLE,
	FOLLOW
}

var current_state = FollowerState.IDLE

signal enemy_attacked

func _physics_process(delta):
	var player = get_parent().get_node("Player")
	if mov_direction == Vector2.ZERO:
		animTree.get("parameters/playback").travel("Idle")
	else:
		knockback_dir = mov_direction
		animTree.get("parameters/playback").travel("Move")
	animTree.set("parameters/Idle/BlendSpace2D/blend_position", mov_direction)
	animTree.set("parameters/Move/BlendSpace2D/blend_position", mov_direction)

	match current_state:
		FollowerState.IDLE:
			if isfollowing:
				if checkplayerdistance(player):
					animTree.get("parameters/playback").travel("Idle")
				else:
					current_state = FollowerState.FOLLOW
			else:
				animTree.get("parameters/playback").travel("Idle")
		FollowerState.FOLLOW:
			if !checkplayerdistance(player):
				accelerate_towards_point(player, delta)
				move_and_slide()
				animTree.get("parameters/playback").travel("Move")
			else:
				current_state = FollowerState.IDLE

func checkplayerdistance(player):
	var distance_squared = (player.position.x - global_position.x)**2 + (player.position.y - global_position.y)**2
	if distance_squared <= radius_squared:
		playerCollision.target_position = player.position - global_position
		if playerCollision.is_colliding():
			return true
		else:
			return false

func accelerate_towards_point(point, delta):
	var movement = mov_direction * Speed
	mov_direction = (point.position - position).normalized()
	velocity = movement + (knockback * 2)
	velocity = velocity.move_toward(mov_direction * Speed, 200 * delta)
	animTree.get("parameters/playback").travel("Move")
	animTree.set("parameters/Idle/BlendSpace2D/blend_position", mov_direction)
	animTree.set("parameters/Move/BlendSpace2D/blend_position", mov_direction)
