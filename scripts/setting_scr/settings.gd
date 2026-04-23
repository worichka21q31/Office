extends Node2D

var save_path = "user://SaveSetings.txt"

@onready var sfx_slider = $Effect_slider
@onready var music_slider = $Music_slider
@onready var master_slider = $Master_slider



func _ready() -> void:
	var sender_node = $CenterContainer/buttensmenu/back_to_menu
	sender_node.save_signal.connect(signal_received)
	load_settings()
	Music.play_menu_music()

func signal_received():
	save_settings()

func save_settings():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(sfx_slider.value)
	file.store_var(music_slider.value)
	file.store_var(master_slider.value)
	file.close()

func load_settings():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		
		sfx_slider.value = file.get_var(sfx_slider.value)
		music_slider.value = file.get_var(music_slider.value)
		master_slider.value = file.get_var(master_slider.value)

	
		file.close()
