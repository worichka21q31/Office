extends PanelContainer

const dur_an = 0.3
var min_value: float = 0.0
var max_value: float = 100.0
var value: float = 100.0:
	set = set_value

@onready var proj_node = get_node_or_null("TextureRect")

var progress_shader : ShaderMaterial
var tween: Tween

func _ready() -> void:
	if proj_node:
		progress_shader = proj_node.material as ShaderMaterial
	upd_texture(0)

func _process(_delta) -> void:
	if value != global_variable.stamina:
		value = global_variable.stamina

func set_value(new_value: float):
	var diff = new_value - value
	value = clampf(new_value, min_value, max_value)
	
	if progress_shader:
		upd_texture(sign(diff))

func upd_texture(direction: int):
	if not progress_shader: return
	
	var progress = value / max_value
	
	if direction < 0:
		get_tween().tween_property(progress_shader, "shader_parameter/progress_tail", progress, dur_an)
		progress_shader.set_shader_parameter("progress", progress)
	
	elif direction > 0:
		get_tween().tween_property(progress_shader, "shader_parameter/progress", progress, dur_an)
		progress_shader.set_shader_parameter("progress_tail", progress)
	
	else:
		progress_shader.set_shader_parameter("progress_tail", progress)
		progress_shader.set_shader_parameter("progress", progress)

func get_tween() -> Tween:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	return tween
