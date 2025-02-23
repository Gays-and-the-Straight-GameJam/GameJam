extends Node2D

const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := Color.BLUE_VIOLET

var scroll_speed := base_speed
var speed_up := false

var line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	["ISS ORIRI"],
	["Programming", "Ethan Graham", "Alexander Rabinovich"],
	["Art", "Luis Canales", "Alexander Rabinovich"],
	["Music", "Created by: Vrymaa + Vannipat of freesound.org and Inavision of pixabay.com", "Implemented by: Alexander Rabinovich"],
	["Sound Effects", "Explosion by freesound_community of pixabay.com", "Alarm by mixkit.co"],
	["Testers", "Luis Canales", "Ethan Graham", "Alexander Rabinovich"],
	[
		"Tools used",
		"Developed with Godot Engine 4.3",
		"https://godotengine.org/license",
		"",
		"Art created with Aseprite",
		"https://www.aseprite.org"
	],
	["Final thoughts", "We challenged ourselves as first time devs", "And we will be giving ourselves a pat on the back", "For releasing a semi-complete product from Alexander", 
	"It's nerf or nothing from Luis", "I hated it, but no it was interesting from Ethan"]
]

func _ready():
	line = $CreditsContainer/Line

func _process(delta):
	scroll_speed = base_speed * (speed_up_multiplier if speed_up else 1.0) * delta
	
	if section_next:
		section_timer += delta * (speed_up_multiplier if speed_up else 1.0)
		if section_timer >= section_time:
			section_timer -= section_time
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	else:
		line_timer += delta * (speed_up_multiplier if speed_up else 1.0)
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if lines.size() > 0:
		for l in lines.duplicate():
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started and not finished:
		finish()

func finish():
	if not finished:
		finished = true
		get_tree().change_scene("res://Levels/Menus/main_menu.tscn")

func add_line():
	if section.empty():
		section_next = true
		return
	
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	elif event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	elif event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
