extends SubViewportContainer

@onready var wireMiniGame = get_node(".")
@onready var parent = self.wireMiniGame.get_parent().get_parent()
@onready var star1 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/star.tscn").instantiate()
@onready var star2 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/star.tscn").instantiate()
@onready var sword1 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/sword.tscn").instantiate()
@onready var sword2 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/sword.tscn").instantiate()
@onready var cannon1 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/cannon.tscn").instantiate()
@onready var cannon2 = preload("res://Levels/Mini-games/Mini-game-mini-scenes/cannon.tscn").instantiate()
@onready var button = $SubViewport/Button

@onready var left = [Vector2(50,100),Vector2(50,200),Vector2(50,300)]
@onready var right = [Vector2(350,100),Vector2(350,200),Vector2(350,300)]
@onready var leftNodes = ["%pointOne","%pointTwo","%pointThree"]
@onready var rightNodes = ["%pointFour","%pointFive","%pointSix"]

@onready var randomizedLeft = self.leftNodes.duplicate(true)
@onready var randomizedRight = self.rightNodes.duplicate(true)

@onready var rootNode = $".."

var clicks = []
var drawable = false
var starSolved = false
var swordSolved = false
var cannonSolved = false

func _ready() -> void:
	
	button.connect("pressed",_on_button_pressed)
	
	# randomized sprite placement
	randomizedLeft.shuffle()
	randomizedRight.shuffle()
	print(randomizedLeft)
	print(randomizedRight)
	
	get_node(randomizedLeft[0]).add_child(star1)
	get_node(randomizedRight[0]).add_child(star2)
	star1.position = left[leftNodes.find(randomizedLeft[0])]
	star2.position = right[rightNodes.find(randomizedRight[0])]
	randomizedLeft.pop_front()
	randomizedRight.pop_front()
	get_node(randomizedLeft[0]).add_child(sword1)
	get_node(randomizedRight[0]).add_child(sword2)
	sword1.position = left[leftNodes.find(randomizedLeft[0])]
	sword2.position = right[rightNodes.find(randomizedRight[0])]
	randomizedLeft.pop_front()
	randomizedRight.pop_front()
	get_node(randomizedLeft[0]).add_child(cannon1)
	get_node(randomizedRight[0]).add_child(cannon2)
	cannon1.position = left[leftNodes.find(randomizedLeft[0])]
	cannon2.position = right[rightNodes.find(randomizedRight[0])]
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("select"):
		var mouse_click = %SubViewport.get_viewport().get_mouse_position()
		clicks.append(mouse_click)
		if clicks.size() > 2:
			clicks.pop_front()
			clicks.pop_front()
		print(clicks)
		if clicks.size() == 2:
			drawable = true
			if star1.position.distance_to(clicks[0]) <= 20 && star2.position.distance_to(clicks[1]) <= 20 && starSolved == false:
				%starWire.add_point(clicks[0])
				%starWire.add_point(clicks[1])
				starSolved = true
				print("Connected")
			elif star2.position.distance_to(clicks[0]) <= 20 && star1.position.distance_to(clicks[1]) <= 20 && starSolved == false:
				%starWire.add_point(clicks[0])
				%starWire.add_point(clicks[1])
				starSolved = true
				print("Connected Reverse")
			elif sword1.position.distance_to(clicks[0]) <= 20 && sword2.position.distance_to(clicks[1]) <= 20 && swordSolved == false:
				%swordWire.add_point(clicks[0])
				%swordWire.add_point(clicks[1])
				swordSolved = true
				print("Connected")
			elif sword2.position.distance_to(clicks[0]) <= 20 && sword1.position.distance_to(clicks[1]) <= 20 && swordSolved == false:
				%swordWire.add_point(clicks[0])
				%swordWire.add_point(clicks[1])
				swordSolved = true
				print("Connected Reverse")
			elif cannon1.position.distance_to(clicks[0]) <= 20 && cannon2.position.distance_to(clicks[1]) <= 20 && cannonSolved == false:
				%cannonWire.add_point(clicks[0])
				%cannonWire.add_point(clicks[1])
				cannonSolved = true
				print("Connected")
			elif cannon2.position.distance_to(clicks[0]) <= 20 && cannon1.position.distance_to(clicks[1]) <= 20 && cannonSolved == false:
				%cannonWire.add_point(clicks[0])
				%cannonWire.add_point(clicks[1])
				cannonSolved = true
				print("Connected Reverse")

func _on_button_pressed():
		if starSolved && swordSolved && cannonSolved:
			GlobalSignals.wireGameCompleted.emit(true)
			GlobalSignals.inMiniGame.emit(false)
			parent.solved = true
			rootNode.queue_free()

func _on_wire_mini_game_popup_hide() -> void:
	clicks = []
	GlobalSignals.inMiniGame.emit(false)
	rootNode.queue_free()
