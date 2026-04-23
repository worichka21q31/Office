extends CanvasLayer

@onready var color_rect: ColorRect = $Fade

func _ready() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	change_alpha(1.)
	fade(0.0, 1.5)

func change_alpha(alpha:float):
	color_rect.color.a = alpha

func fade(alpha: float , duration: float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "color:a", alpha, duration)
	return tween
