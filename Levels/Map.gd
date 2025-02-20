extends Node2D


@onready var fuseProp = preload("res://Levels/Props/fuseProp.tscn")
@onready var ControlPanel = preload("res://Levels/Props/ControlPanel.tscn")
@onready var spawn_count = GlobalScript.numPuzzlesPerLevel



var all_nodes := []

func _ready() -> void:
	all_nodes.append_array($Minigames.get_children())
	spawn_nodes()


func spawn_nodes():
	if GlobalScript.level > spawn_count.size():
		return 

	all_nodes.shuffle()

	for node in all_nodes:
		for child in node.get_children():
			child.queue_free()

	var valid_nodes = []
	for node in all_nodes:
		if node.name.begins_with("ElectricalRoomWires") or node.name.begins_with("ShippingContainer"):
			valid_nodes.append(node)

	var nodes_to_process = min(spawn_count[GlobalScript.level - 1], valid_nodes.size())
	for i in range(nodes_to_process):
		var node = valid_nodes[i]
		print("Processing node: ", node.name, " | Path: ", node.get_path())

		if node.name.begins_with("ElectricalRoomWires"):
				var fuseProp = fuseProp.instantiate()
				node.add_child(fuseProp)
		elif node.name.begins_with("ShippingContainer"):
				var ControlPanel = ControlPanel.instantiate()
				all_nodes[i].add_child(ControlPanel)
