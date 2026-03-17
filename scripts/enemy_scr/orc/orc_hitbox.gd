extends Area2D
@onready var Me = $".."
const popup_scene = preload("res://scenes/enemy/damage_popup.tscn")

func take_damege(damage):
	Me.hp -= damage
	Me.animated_sprite.hit_Flash()
	spawn_popup(damage)

func spawn_popup(damage: float):
	var popup = popup_scene.instantiate()
	get_tree().current_scene.add_child(popup)
	
	var player_pos = get_tree().get_first_node_in_group("player").global_position
	var direction = (global_position - player_pos).normalized()
	#Передает позицию существа, которое вызывает эту херню и не еби мозги хули ты это читаешь?
	popup.global_position = global_position
	popup.setup(damage, direction)
