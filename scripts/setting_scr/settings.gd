extends Node2D

var save_path = "user://SaveSetting.json"

@onready var sfx_slider = $Effect_slider
@onready var music_slider = $Music_slider
@onready var master_slider = $Master_slider

func _ready() -> void:
	var sender_node = $CenterContainer/buttensmenu/back_to_menu
	sender_node.save_signal.connect(signal_received)
	print(sfx_slider.value)
	Music.play_menu_music()
	load_settings()

func signal_received():
	print(sfx_slider.value)

func save_settings(data: Dictionary) -> bool:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		print("Ошибка: не удалось открыть файл для записи")
		return false
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	return true

func data_save():
	var setting_data = {
		"sfx_value": sfx_slider.value,
		"music_value": music_slider.value,
		"master_value": master_slider.value
	}
	save_settings(setting_data)

func load_settings():
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		return
	var file_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	json.parse(file_text)
	
	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		return
	
	if data.has("sfx_value"):
		sfx_slider.value = data["sfx_value"]
	else:
		print("Не дошел sfx")
	
	if data.has("music_value"):
		music_slider.value = data["music_value"]
	else:
		print("Не дошел music")
	
	if data.has("master_value"):
		master_slider.value = data["master_value"]
	else:
		print("Не дошел master")
