extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var current_music_path: String = ""
var non_looping_scene = ["res://Levels/Menus/OOT.tscn"]

func _ready():
	if not music_player.is_inside_tree():
		add_child(music_player)
	music_player.bus = "Music"
	play_music()
 

func play_music():
	var current_scene = get_tree().current_scene.scene_file_path
	
	if current_scene == "res://Levels/Menus/main_menu.tscn":
		music_player.stream = preload("res://Assets/Music/Main_menu_theme.wav")
	elif current_scene == "res://Levels/Menus/Win.tscn":
		music_player.stream = preload("res://Assets/Music/Win_Song.mp3")
	elif current_scene == "res://Levels/Menus/OOT.tscn":
		play_sfx(preload("res://Assets/Music/Explosion.mp3"))
	elif current_scene == "res://Levels/Map.tscn":
		music_player.stream = preload("res://Assets/Music/play_music.mp3")
	
	if current_scene in non_looping_scene:
		music_player.disconnect("finished", _on_music_finished)
	else:
		if not music_player.is_connected("finished", _on_music_finished):
			music_player.connect("finished", _on_music_finished)
	
	music_player.volume_db = -10
	music_player.play()


func _on_music_finished():
	music_player.play()
	
func stop_music():
	if music_player:
		music_player.stop()
		
func play_sfx(sound: AudioStream):
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Sfx"
	sfx_player.stream = sound
	add_child(sfx_player)
	sfx_player.play()

	sfx_player.connect("finished", sfx_player.queue_free)
