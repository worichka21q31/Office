extends Item


func _ready() -> void:
	icon_path = "res://assets/item_ass/HpUp.png"
	var icon_texture = load(icon_path)
	sprite.texture = icon_texture

func apply_effect() -> void:
	global_variable.hp += 100
	pass

func collect():
	apply_effect()
	item_collected.emit(item_id)
	queue_free()
