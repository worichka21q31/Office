extends Area2D

var take_damage_cadr: int = 1
var rng = RandomNumberGenerator.new()
var area: Area2D = null
@onready var anim = $AnimatedSprite2D
var enemy_in_area: bool = false

func _ready() -> void:
	rng.randomize()

func _on_area_entered(entered_area: Area2D) -> void:
	if entered_area.is_in_group("enemy"):
		enemy_in_area = true
		area = entered_area

func _on_area_exited(_exited_area: Area2D) -> void:
	if _exited_area.is_in_group("enemy"):
		enemy_in_area = false
		area = null 

func _process(_delta):
	if enemy_in_area and anim.frame >= take_damage_cadr:
		var random_number = rng.randi_range(1, 100)
		if random_number <= global_variable.crit_chache:
			area.take_damege(global_variable.damage * global_variable.crit_damage)
		elif random_number > global_variable.crit_chache :
			area.take_damege(global_variable.damage)
		enemy_in_area = false
		area = null

func _on_animated_sprite_2d_animation_finished() -> void:
	global_variable.he_is_atack = false
	self.queue_free()
