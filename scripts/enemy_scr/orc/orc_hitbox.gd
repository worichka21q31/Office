extends Area2D
@onready var Me = $".."

func take_damege(damage):
	Me.hp -= damage
	Me.animated_sprite.hit_Flash()
