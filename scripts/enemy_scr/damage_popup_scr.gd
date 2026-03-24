extends Node2D

@onready var label: Label = $Hp
var time_sec: float = 0.8 

func setup(damage: float, direction: Vector2):
	label.text = ("%.1f" % damage).replace(".", ",")
	# Я хочу не точку, а запятую!
	
	var spread_distance = 100.0
	var jump_height = -50.0
	
	var fall_boost = 1.0
	if direction.y > 0:
		fall_boost = 2.0 
		# Херово летит вниз, поэтому чуть увелючу
	
	var target_pos = position + (direction * spread_distance * fall_boost) + Vector2(0, jump_height)
	var tween = create_tween().set_parallel(true)
	
	#Анимации
	tween.tween_property(self, "position", target_pos, time_sec).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	#Анимация передрочки в полете
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#Анимация пропадания с задержкой
	tween.tween_property(self, "modulate:a", 0.0, time_sec).set_delay(0.3)
	
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
