extends CharacterBody2D

@onready var objectID = self.get_instance_id()
@onready var playerNode = get_tree().get_first_node_in_group("Player")
@onready var playerID = playerNode.get_instance_id()
@onready var detectionArea = get_node("DetectionArea")
@onready var root = $".".get_parent()
@onready var solved = false

var entered = false
var interactedWith = false

func _ready() -> void:
	# Signal connections
	detectionArea.connect("body_entered",_on_body_entered)
	detectionArea.connect("body_exited",_on_body_exited)
	GlobalSignals.interact.connect(_on_interact)
	pass

func _physics_process(delta: float) -> void:
	pass
	
func _on_interact(state : bool, objectId : int):
	if state == true and objectId == self.objectID and self.solved == false:
		GlobalSignals.batteryPickedUp.emit(true)
		print("Interacted with: " + str(self.objectID))
		self.queue_free()
	else: 
		GlobalSignals.batteryPickedUp.emit(false)
		
		
func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		entered = true
		GlobalSignals.objectIDSignal.emit(self.objectID)

func _on_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		entered = false
		GlobalSignals.objectIDSignal.emit(0)
