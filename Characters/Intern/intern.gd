extends CharacterBody2D

@export var Speed: int = 100
@export var radiuslimit = 50

@onready var animTree = $AnimationTree
@onready var playerCollision = $PlayerCollision

var mov_direction = Vector2()
var radius_squared = radiuslimit**2
var isfollowing = true

enum FollowerState{
	IDLE,
	FOLLOW
}

var current_state = FollowerState.IDLE

func _ready():
	playerCollision.enabled = true

func _physics_process(delta):
	if GlobalScript.inCutscene == false:
		var player = get_parent().get_node_or_null("Player")
		if player == null:
			return
		if mov_direction == Vector2.ZERO:
			animTree.get("parameters/playback").travel("Idle")
		else:
			animTree.get("parameters/playback").travel("Walk")
		animTree.set("parameters/Idle/blend_position", mov_direction)
		animTree.set("parameters/Walk/blend_position", mov_direction)
		match current_state:
			FollowerState.IDLE:
				if isfollowing and !checkplayerdistance(player):
					current_state = FollowerState.FOLLOW
			FollowerState.FOLLOW:
				if !checkplayerdistance(player):
					accelerate_towards_point(player, delta)
					move_and_slide()
				else:
					current_state = FollowerState.IDLE

func checkplayerdistance(player):
	var distance_squared = (player.position - global_position).length_squared()
	if distance_squared <= radius_squared:
		playerCollision.target_position = (player.position - global_position).normalized() * radiuslimit
		playerCollision.force_raycast_update()
		if playerCollision.is_colliding():
			return true
		else:
			return false

func accelerate_towards_point(player, delta):
	if player == null:
		return
	var player_velocity = player.velocity.normalized()
	var target_position = player.position - (player_velocity * radiuslimit)
	if player_velocity.length() > 0:
		mov_direction = (target_position - position).normalized()
		velocity = velocity.move_toward(mov_direction * Speed, 200 * delta)
	move_and_slide()
		
	animTree.get("parameters/playback").travel("Walk")
	animTree.set("parameters/Idle/blend_position", mov_direction)
	animTree.set("parameters/Walk/blend_position", mov_direction)
