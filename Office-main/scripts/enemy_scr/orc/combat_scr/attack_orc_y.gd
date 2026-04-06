extends Area2D

var take_damage_cadr: int = 1
var crit_damage: float  = 1.5
var crit_chache: int  = 10
var damage: float = 1
var rng = RandomNumberGenerator.new()
@onready var anim = $AnimatedSprite2D
var player_in_area: bool = false

func _ready() -> void:
	rng.randomize()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_in_area = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_in_area = false

func _process(_delta):
	if player_in_area and anim.frame >= take_damage_cadr:
		var random_number = rng.randi_range(1, 100)
		if random_number <= crit_chache:
			global_variable.hp -= damage * crit_damage
		elif random_number > crit_chache :
			global_variable.hp -= damage 
		player_in_area = false
		

func _on_animated_sprite_2d_animation_finished() -> void:
	self.queue_free()
