extends SubViewportContainer

@onready var DragNDropminigame = get_node(".")
@onready var parent = self.DragNDropminigame.get_parent().get_parent()
@onready var Box = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_box.tscn").instantiate()
@onready var Disk = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_disk.tscn").instantiate()
@onready var Rose = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_rose.tscn").instantiate()
@onready var Star = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_star.tscn").instantiate()
@onready var Cactus = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_cactus.tscn").instantiate()
@onready var Eye = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_eye.tscn").instantiate()
@onready var Coins = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/drag_coins.tscn").instantiate()
@onready var DropBox = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropBox.tscn").instantiate()
@onready var DropDisk = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropDisk.tscn").instantiate()
@onready var DropRose = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropRose.tscn").instantiate()
@onready var DropStar = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabNDropStar.tscn").instantiate()
@onready var DropCactus = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropCactus.tscn").instantiate()
@onready var DropEye = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropEye.tscn").instantiate()
@onready var DropCoins = preload("res://Levels/Mini-games/Mini-game-mini-scenes/DragNDrop/GrabnDropCoins.tscn").instantiate()
@onready var viewport = %SubViewport

@onready var top = [Vector2(120, 350),Vector2(160, 350),Vector2(200, 350),Vector2(240, 350),Vector2(280, 350),Vector2(320, 350), Vector2(80, 350)]
@onready var bottom = [Vector2(142, 250),Vector2(145, 125),Vector2(237, 250),Vector2(235,125),Vector2(323, 250),Vector2(325, 125), Vector2(67, 125)]
@onready var topNodes = ["%point1","%point2","%point3","%point4","%point5","%point6", "%point13"]
@onready var bottomNodes = ["%point7","%point8","%point9","%point10","%point11","%point12", "%point14"]
@onready var mouse_offset = Vector2.ZERO
@onready var randomizedTop = self.topNodes.duplicate(true)
@onready var randomizedBottom = self.bottomNodes.duplicate(true)

@onready var rootNode = $".."

var BoxSolved = false
var DiskSolved = false
var RoseSolved = false
var StarSolved = false
var CactusSolved = false
var EyeSolved = false
var CoinsSolved = false

var currently_dragging = null

	
func _ready() -> void:
	rootNode.popup_hide.connect(_on_drag_n_drop_mini_game_popup_hide)
	
	# randomized sprite placement
	randomizedTop.shuffle()
	randomizedBottom.shuffle()
	print(randomizedTop)
	print(randomizedBottom)
	
	get_node(randomizedTop[0]).add_child(Box)
	get_node(randomizedBottom[0]).add_child(DropBox)
	Box.position = top[topNodes.find(randomizedTop[0])]
	DropBox.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Disk)
	get_node(randomizedBottom[0]).add_child(DropDisk)
	Disk.position = top[topNodes.find(randomizedTop[0])]
	DropDisk.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Rose)
	get_node(randomizedBottom[0]).add_child(DropRose)
	Rose.position = top[topNodes.find(randomizedTop[0])]
	DropRose.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Star)
	get_node(randomizedBottom[0]).add_child(DropStar)
	Star.position = top[topNodes.find(randomizedTop[0])]
	DropStar.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Cactus)
	get_node(randomizedBottom[0]).add_child(DropCactus)
	Cactus.position = top[topNodes.find(randomizedTop[0])]
	DropCactus.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Eye)
	get_node(randomizedBottom[0]).add_child(DropEye)
	Eye.position = top[topNodes.find(randomizedTop[0])]
	DropEye.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	get_node(randomizedTop[0]).add_child(Coins)
	get_node(randomizedBottom[0]).add_child(DropCoins)
	Coins.position = top[topNodes.find(randomizedTop[0])]
	DropCoins.position = bottom[bottomNodes.find(randomizedBottom[0])]
	randomizedTop.pop_front()
	randomizedBottom.pop_front()
	
func _physics_process(delta: float) -> void:
	if currently_dragging:
		currently_dragging.global_position = get_global_mouse_position() - mouse_offset
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			for node in [Box, Disk, Rose, Star, Cactus, Eye, Coins]:
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
	if node == Box:
		drop_zone = DropBox
	elif node == Disk:
		drop_zone = DropDisk
	elif node == Rose:
		drop_zone = DropRose
	elif node == Star:
		drop_zone = DropStar
	elif node == Cactus:
		drop_zone = DropCactus
	elif node == Eye:
		drop_zone = DropEye
	elif node == Coins:
		drop_zone = DropCoins
	
	if drop_zone and is_inside_drop_zone(node, drop_zone):
		node.global_position = drop_zone.global_position
		if node == Box:
			BoxSolved = true
		elif node == Disk:
			DiskSolved = true
		elif node == Rose:
			RoseSolved = true
		elif node == Star:
			StarSolved = true
		elif node == Cactus:
			CactusSolved = true
		elif node == Eye:
			EyeSolved = true
		elif node == Coins:
			CoinsSolved = true
			
	if BoxSolved && DiskSolved && RoseSolved && StarSolved && CactusSolved && EyeSolved && CoinsSolved :
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
