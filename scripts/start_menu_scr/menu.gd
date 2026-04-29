extends Node2D

var save_path = "user://SaveSetting.json"

@onready var fade: CanvasLayer = $fade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.play_menu_music()
	load_settings()
	fade.change_alpha(0.0)


func _on_newgame_pressed() -> void:
	get_viewport().gui_disable_input = true #отключает навигацию стрелочками и энтер
	await fade.fade(1, 1.5).finished
	# Переход в ?
	get_tree().change_scene_to_file("res://scenes/levels/1.tscn")


func _on_settings_pressed() -> void:
	# Переход в настройки
	get_tree().change_scene_to_file("res://scenes/setting/settings.tscn")

func load_settings():
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		return
	var file_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	json.parse(file_text)
	
	var data = json.data
	
	if data.has("sfx_value"):
		AudioServer.set_bus_volume_db(1, linear_to_db(data["sfx_value"]))
		print("Дошел")
	else:
		print("не дошел")
	
	if data.has("music_value"):
		AudioServer.set_bus_volume_db(2, linear_to_db(data["music_value"]))
	else:
		print("не дошел")
	
	if data.has("master_value"):
		AudioServer.set_bus_volume_db(0, linear_to_db(data["master_value"]))
	else:
		print("не дошел")
func _on_quit_pressed() -> void:
	# Выход
	get_tree().quit()
