extends CharacterBody2D

@onready var objectID = self.get_instance_id()
@onready var playerNode = get_tree().get_first_node_in_group("Player")
@onready var playerID = playerNode.get_instance_id()
@onready var detectionArea = get_node("DetectionArea")

var entered = false

func _ready() -> void:
	# Signal connections
	detectionArea.connect("body_entered",_on_body_entered)
	detectionArea.connect("body_exited",_on_body_exited)
	pass

func _physics_process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		entered = true
		print("Player Entered: " + str(entered))

func _on_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		entered = false
		print("Player Entered: " + str(entered))
