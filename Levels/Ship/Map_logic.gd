extends Node2D

@onready var fuseProp = preload("res://Levels/Props/fuseProp.tscn")
@onready var batteryProp = preload("res://Levels/Props/battery.tscn")
@onready var batterySlotProp = preload("res://Levels/Props/batterySlotProp.tscn")
@onready var controlProp = preload("res://Levels/Props/ControlPanel.tscn")
@onready var screenProp = preload("res://Levels/Props/brokenScreenProp.tscn")
@onready var intern = preload("res://Characters/Intern/Intern.tscn")

@onready var batterySlotfull = preload("res://Levels/Mini-games/Mini-game-mini-scenes/batterySlotFull.tscn")
@onready var root = $"."

@onready var nodeList = [
	$fuseNodeOne,$fuseNodeTwo,$fuseNodeThree,$screenNodeOne,$screenNodeTwo,$screenNodeThree,
	$screenNodeFour,$batterySlotNodeOne,$batterySlotNodeTwo,$batterySlotNodeThree,$batterySlotNodeFour,
	$controlNodeOne,$controlNodeTwo]

@onready var batteryNodes = [$batteryNodeOne, $batteryNodeTwo, $batteryNodeThree, $batteryNodeFour]

@onready var level = GlobalScript.level
@onready var numPuzzles = GlobalScript.numPuzzlesPerLevel[level-1]

@onready var currentPuzzles = []


func _ready() -> void:
	if GlobalScript.inCutscene == false:
		var internInstance = intern.instantiate()
		root.add_child(internInstance)
		internInstance.position = $InternSpawnPoint.position
	_spawnnodes()

func _spawnnodes():
	
	for i in numPuzzles:
		var randNode = nodeList.pick_random()
		currentPuzzles.append(randNode)
		nodeList.pop_at(nodeList.find(randNode))
		
	for node in nodeList:
		if "batterySlot" in node.name:
			node.add_child(batterySlotfull.instantiate())
	
	for node in currentPuzzles:
		if "fuse" in node.name:
			node.add_child(fuseProp.instantiate())
		elif "battery" in node.name:
			var battery = batteryNodes.pick_random()
			node.add_child(batterySlotProp.instantiate())
			battery.add_child(batteryProp.instantiate())
			batteryNodes.pop_at(batteryNodes.find(battery))
		elif "control" in node.name:
			node.add_child(controlProp.instantiate())
		elif "screen" in node.name:
			node.add_child(screenProp.instantiate())
