extends PanelContainer

const dur_an = 0.7
var min_value: float  = 0.0;
var max_value: float  = 100.0;
var value: float  = global_variable.hp:
	set = set_value

@onready var label = $ProjTectured/Label
@onready var progress_shader : ShaderMaterial = %ProjTectured.material

var tween: Tween


func _ready() -> void:
	upd_texture(0)
func _process(_delta) -> void:
	if global_variable.hp > 0:
		label.text = " " + str(int(global_variable.hp))
	else:
		label.text = " Dead:("
	value = global_variable.hp
func set_value(new_value: float):
	var diff = new_value - value
	value = clampf(new_value, min_value ,max_value)
	
	if progress_shader:
		upd_texture(sign(diff))
	

func upd_texture(direction: int):
	var progress = value / (max_value - min_value)
	
	if (direction < 0):
		get_tween().tween_property(progress_shader, "shader_parameter/progress_tail", progress, dur_an)
		progress_shader.set_shader_parameter("progress", progress)
	elif (direction > 0):
		get_tween().tween_property(progress_shader, "shader_parameter/progress", progress, dur_an)
		progress_shader.set_shader_parameter("progress_tail", progress)
	else:
		progress_shader.set_shader_parameter("progress_tail", progress)
		progress_shader.set_shader_parameter("progress", progress)

func get_tween() -> Tween:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT)
	return tween
