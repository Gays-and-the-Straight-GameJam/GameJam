extends SubViewportContainer

@onready var DragNDropminigame = get_node(".")
@onready var parent = self.DragNDropminigame.get_parent().get_parent()
@onready var Circle1 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_circle.tscn").instantiate()
@onready var Circle2 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_circle.tscn").instantiate()
@onready var Triangle1 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_triangle.tscn").instantiate()
@onready var Square1 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_square.tscn").instantiate()
@onready var Square2 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_square.tscn").instantiate()
@onready var Triangle2 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_triangle.tscn").instantiate()
@onready var DropCircle1 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropCircle.tscn").instantiate()
@onready var DropCircle2 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropCircle.tscn").instantiate()
@onready var DropTriangle1 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropTriangle.tscn").instantiate()
@onready var DropSquare1 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropSquare.tscn").instantiate()
@onready var DropSquare2 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropSquare.tscn").instantiate()
@onready var DropTriangle2 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropTriangle.tscn").instantiate()
@onready var viewport = %SubViewport

@onready var top = [Vector2(120, 350),Vector2(160, 350),Vector2(200, 350),Vector2(240, 350),Vector2(280, 350),Vector2(320, 350)]
@onready var bottom = [Vector2(100,125),Vector2(145, 125),Vector2(190, 125),Vector2(235,125),Vector2(280, 125),Vector2(325, 125)]
@onready var topNodes = ["%point1","%point2","%point3","%point4","%point5","%point6"]
@onready var bottomNodes = ["%point7","%point8","%point9","%point10","%point11","%point12"]
@onready var mouse_offset = Vector2.ZERO
@onready var randomizedTop = self.topNodes.duplicate(true)
@onready var randomizedBottom = self.bottomNodes.duplicate(true)

@onready var rootNode = $".."

var Circle1Solved = false
var Circle2Solved = false
var Square1Solved = false
var Square2Solved = false
var Triangle1Solved = false
var Triangle2Solved = false

var currently_dragging = null

	
func _ready() -> void:
	rootNode.popup_hide.connect(_on_drag_n_drop_mini_game_popup_hide)
	
	# randomized sprite placement
	randomizedTop.shuffle()
	randomizedBottom.shuffle()
	print(randomizedTop)
	print(randomizedBottom)
	
	get_node(randomizedTop[0]).add_child(Circle1)
	get_node(randomizedBottom[0]).add_child(DropCircle1)
	Circle1.position = top[topNodes.find(randomizedTop[0])]
	DropCircle1.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Square1)
	get_node(randomizedBottom[0]).add_child(DropSquare1)
	Square1.position = top[topNodes.find(randomizedTop[0])]
	DropSquare1.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Circle2)
	get_node(randomizedBottom[0]).add_child(DropCircle2)
	Circle2.position = top[topNodes.find(randomizedTop[0])]
	DropCircle2.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Triangle1)
	get_node(randomizedBottom[0]).add_child(DropTriangle1)
	Triangle1.position = top[topNodes.find(randomizedTop[0])]
	DropTriangle1.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Square2)
	get_node(randomizedBottom[0]).add_child(DropSquare2)
	Square2.position = top[topNodes.find(randomizedTop[0])]
	DropSquare2.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Triangle2)
	get_node(randomizedBottom[0]).add_child(DropTriangle2)
	Triangle2.position = top[topNodes.find(randomizedTop[0])]
	DropTriangle2.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	
func _physics_process(delta: float) -> void:
	if currently_dragging:
		currently_dragging.global_position = get_global_mouse_position() - mouse_offset
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			for node in [Circle1, Circle2, Square1, Square2, Triangle1, Triangle2]:
				var size = node.get_child(0).texture.get_size() if node.get_child_count() > 0 else Vector2(50, 50)
				if is_inside(node, event.global_position, size):
					currently_dragging = node
					mouse_offset = event.global_position - node.global_position
					break
		elif not event.pressed:
			if currently_dragging:
				check_drop_zone(currently_dragging)
				currently_dragging = null
				
				
func check_drop_zone(node):
	var drop_zone = null
	if node == Circle1:
		drop_zone = DropCircle1
	elif node == Circle2:
		drop_zone = DropCircle2
	elif node == Square1:
		drop_zone = DropSquare1
	elif node == Triangle1:
		drop_zone = DropTriangle1
	elif node == Square2:
		drop_zone = DropSquare2
	elif node == Triangle2:
		drop_zone = DropTriangle2
	
	if drop_zone and is_inside_drop_zone(node, drop_zone):
		node.global_position = drop_zone.global_position
		if node == Circle1:
			Circle1Solved = true
		elif node == Circle2:
			Circle2Solved = true
		elif node == Square1:
			Square1Solved = true
		elif node == Triangle1:
			Triangle1Solved = true
		elif node == Square2:
			Square2Solved = true
		elif node == Triangle2:
			Triangle2Solved = true
			
	if Circle1Solved && Circle2Solved && Triangle2Solved && Square1Solved && Square2Solved && Triangle1Solved :
		GlobalSignals.DragNDropCompleted.emit(true)
		GlobalSignals.inMiniGame.emit(false)
		parent.solved = true
		rootNode.queue_free()
		
func _on_drag_n_drop_mini_game_popup_hide() -> void:
	GlobalSignals.inMiniGame.emit(false)
	#rootNode.queue_free()

func is_inside(node: Node2D, position: Vector2, size: Vector2) -> bool:
	return Rect2(node.global_position - size / 2, size).has_point(position)

func is_inside_drop_zone(node: Node2D, drop_zone: StaticBody2D) -> bool:
	var drop_size = Vector2(50,50)
	var drop_rect = Rect2(drop_zone.global_position - drop_size / 2, drop_size)
	return drop_rect.has_point(node.global_position)
