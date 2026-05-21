extends Node2D
class_name Item

@export var item_id: String = "0"
@export var item_name: String = "родитель"
@export var item_description: String = "родитель"
@export var icon_path: String = "res://assets/icon.svg"

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Area2D

signal item_collected(item: String)

func _ready() -> void:
	var icon_texture = load(icon_path)
	sprite.texture = icon_texture

func collect():
	apply_effect()
	item_collected.emit(item_id)
	queue_free()


func apply_effect() -> void:
	# Базовый метод, будет переопределён в наследниках
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		collect()
		print_debug("Тронулся")
