extends Node2D

@onready var fade: CanvasLayer = $Fade


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade.change_alpha(1.0)
	fade.fade(0.0, 1.0)
