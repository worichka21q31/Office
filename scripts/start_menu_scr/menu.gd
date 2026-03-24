extends Node2D

@onready var fade: CanvasLayer = $fade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.play_menu_music()
	fade.change_alpha(0.0)


func _on_newgame_pressed() -> void:
	get_viewport().gui_disable_input = true #отключает навигацию стрелочками и энтер
	await fade.fade(1, 1.5).finished
	# Переход в ?
	get_tree().change_scene_to_file("res://scenes/levels/1.tscn")


func _on_settings_pressed() -> void:
	# Переход в настройки
	get_tree().change_scene_to_file("res://scenes/setting/settings.tscn")


func _on_quit_pressed() -> void:
	# Выход
	get_tree().quit()
