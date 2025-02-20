extends Node2D

@onready var fuseProp = preload("res://Levels/Props/fuseProp.tscn")

@onready var electricalRoomWires = get_node("%ElectricalRoomWires")

func _ready() -> void:
	var puzzleOne = fuseProp.instantiate()
	electricalRoomWires.add_child(puzzleOne)
