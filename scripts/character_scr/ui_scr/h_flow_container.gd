extends HFlowContainer

# При ошибке или кривой передачи он встанет не его место
const DEFAULT_ICON = "res://icon.svg"
# ТОЛЬКО ДОЧЕРНЫЕ КЛАССЫ debuff_bar
# Кто передаст сюда, что то другое - гей 
func add_debuff(debuff_scene: PackedScene, duration: float, icon_path: String = ""):
	var instance = debuff_scene.instantiate()
	
	var final_path = icon_path
	if icon_path == "" or !FileAccess.file_exists(icon_path):
		final_path = DEFAULT_ICON
	
	var texture = load(final_path)
	
	var icon_node = instance.get_node_or_null("Icon")
	if !icon_node:
		icon_node = TextureRect.new()
		# Настройки растяжения
		icon_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon_node.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		icon_node.show_behind_parent = true

		instance.add_child(icon_node)
	
	icon_node.texture = texture
	
	add_child(instance)
	instance.custom_minimum_size = Vector2(55, 55)
	
	if instance.has_method("start_act"):
		instance.start_act(duration)
	else:
		print("ТОЛЬКО ДОЧЕРНЫЕ КЛАССЫ debuff_bar")
	
	await get_tree().create_timer(duration).timeout
	remove_debuff(instance)

func remove_debuff(progress_bar_node: ProgressBar):
	if is_instance_valid(progress_bar_node) and progress_bar_node.get_parent() == self:
		progress_bar_node.queue_free()
