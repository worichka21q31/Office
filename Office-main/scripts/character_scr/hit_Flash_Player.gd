extends AnimatedSprite2D

func _ready() -> void:
	material.set_shader_parameter("enabled", false)

func Hit_Flash() -> void:
	material.set_shader_parameter("enabled", true)
	await get_tree().create_timer(0.35).timeout
	material.set_shader_parameter("enabled", false)
