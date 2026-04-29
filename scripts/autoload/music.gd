extends AudioStreamPlayer

const menu_music = preload("res://autoload/Music/elevator-music-vanoss-gaming-background-music.mp3")




var save_path = "user://SaveSetings.txt"

@onready var sfx_slider = Music.sfx_slider
@onready var music_slider = Music.master_slider
@onready var master_slider = Music.master_slider

func _ready() -> void:
	load_audio_settings()


func load_audio_settings():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		
		#print_debug(file.get_var(sfx_slider.value))
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),file.get_var(master_slider.value))
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game effects"),file.get_var(sfx_slider.value))
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game music"),file.get_var(music_slider.value))


	
		file.close()

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return

	stream = music
	volume_db = volume
	play()
	
func play_menu_music():
	_play_music(menu_music)
