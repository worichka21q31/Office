extends ProgressBar


func _ready() -> void:
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

func start_roll_animation(duration: float):
	var tween = create_tween()
	value = max_value
	tween.tween_property(self, "value", 0.0, duration).set_trans(Tween.TRANS_LINEAR)
