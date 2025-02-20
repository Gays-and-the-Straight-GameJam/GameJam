extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var current_music_path: String = ""

func _ready():
	if not music_player.is_inside_tree():
		add_child(music_player)

	music_player.connect("finished", _on_music_finished)
	music_player.volume_db = -10  # Adjust if needed
	music_player.stream = null  # Ensure it starts empty

# 🎵 Function to Play Music
func play_music(music_path: String):
	if current_music_path == music_path:
		return  # Prevent restarting the same song
	
	current_music_path = music_path
	music_player.stream = load(music_path)
	music_player.play()

# 🔇 Function to Stop Music
func stop_music():
	if music_player:
		music_player.stop()
		current_music_path = ""

# 🔁 Ensure Looping
func _on_music_finished():
	music_player.play()
