extends StaticBody2D

@onready var filled = false
@onready var shape = "square"
@onready var objectid = self.get_instance_id()
@onready var Sprite = $Sprite2D
@onready var droppable_area = $Area2D
