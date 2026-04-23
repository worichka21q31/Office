extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var player_hitbox = $Area2D
@onready var bar = $Camera2D/Canvas/HFlowContainer
@onready var walk_sound_timer = $"../Timer"
@onready var saved_text: Label = $Camera2D/Canvas/Saved_text

var save_path = "user://SaveGame.txt"

var movement = movement_vector()
var direction = movement.normalized()
var attack_x_scene = preload("res://scenes/main_character/combat/attack_base.tscn")
var attack_y_scene = preload("res://scenes/main_character/combat/attack_base_y.tscn")
var step_sound = preload("res://autoload/sound_effects/Run.mp3")
var deduff = preload("res://scenes/main_character/ui/debuff_bar.tscn")

var roll_timer: float
var roll_direction = Vector2.ZERO
var prevHP = global_variable.hp

var inventoryPlaceholder = []

func _ready():
	global_variable.is_rolling = false
	global_variable.he_is_atack = false
	add_to_group("player")
	load_game()
	

func can_move() -> bool:
	return !global_variable.he_is_atack and !global_variable.im_Dead

func can_attack() -> bool:
	return !global_variable.he_is_atack and !global_variable.im_Dead and !global_variable.is_rolling

func is_roll_allowed() -> bool:
	return global_variable.stamina >= global_variable.roll_cost and !global_variable.is_rolling and can_attack()

func _process(delta):
	print_debug(position)
	if !global_variable.is_rolling and global_variable.stamina < global_variable.max_stamina:
		global_variable.stamina = move_toward(global_variable.stamina, global_variable.max_stamina, global_variable.stamina_regen * delta)
	
	if global_variable.is_rolling:
		roll_timer -= delta * 1.1
		velocity = roll_direction * global_variable.roll_speed
		
		if roll_timer <= 0:
			global_variable.is_rolling = false
			animated_sprite.play("idle")
		
		move_and_slide()
		return
	
	if can_move():
		movement = movement_vector()
		direction = movement.normalized()
		velocity = global_variable.speed * direction
	else:
		movement = Vector2.ZERO
		direction = Vector2.ZERO
		velocity = global_variable.speed * direction
	
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

	move_and_slide()
	
	if velocity != Vector2.ZERO:
		animated_sprite.play("run")
		if walk_sound_timer.time_left <= 0:
			$AudioStreamPlayer2D.play()
			walk_sound_timer.start(0.35);
		if global_variable.hp <= 0:
			global_variable.im_Dead = true
			animated_sprite.play("die")
	elif can_move():  
		animated_sprite.play("idle")
		if global_variable.hp <= 0:
			global_variable.im_Dead = true
			animated_sprite.play("die")
	if prevHP > global_variable.hp:
		animated_sprite.Hit_Flash()
		prevHP = global_variable.hp
	
	if direction.x > 0 or direction.x < 0:
		start_atack_x()
	elif direction.y > 0 or direction.y < 0:
		start_atack_y()

	if Input.is_action_just_pressed("ui_accept") and is_roll_allowed():
		start_roll()
		
	if Input.is_action_just_pressed("save"):
		save_game()
		saved_text.visible = true;
		await get_tree().create_timer(1.0).timeout
		saved_text.visible = false;

func movement_vector():
	var movement_x = Input.get_action_strength("ui_D") - Input.get_action_strength("ui_A")
	var movement_y = Input.get_action_strength("ui_S") - Input.get_action_strength("ui_W")
	
	return Vector2(movement_x, movement_y)

func start_atack_x():
	if Input.is_action_pressed("left_click") and can_attack():
		global_variable.he_is_atack = true
		var area_instance = attack_x_scene.instantiate()
		if direction.x > 0:
			area_instance.scale.x = 1
		elif direction.x < 0:
			area_instance.scale.x = -1
		animated_sprite.play("idle")
		bar.add_debuff(deduff, 0.6, "res://assets/icon.svg")
		add_child(area_instance)

func start_atack_y():
	if Input.is_action_pressed("left_click") and can_attack():
		global_variable.he_is_atack = true
		var area_instance = attack_y_scene.instantiate()
		if direction.y > 0:
			area_instance.position = Vector2(0, -10)
			area_instance.scale.y = -1
		elif direction.y < 0:
			area_instance.position = Vector2(0, -5)
			area_instance.scale.y = 1
		animated_sprite.play("idle")
		bar.add_debuff(deduff, 0.6, "res://assets/icon.svg")
		add_child(area_instance)

func start_roll():
	if !is_roll_allowed():
		return
	
	global_variable.is_rolling = true
	global_variable.stamina -= global_variable.roll_cost 
	roll_timer = global_variable.roll_duration
	
	if direction != Vector2.ZERO:
		roll_direction = direction
	else:
		roll_direction = Vector2.RIGHT if !animated_sprite.flip_h else Vector2.LEFT
	
	animated_sprite.play("roll")
	bar.add_debuff(deduff, global_variable.roll_duration, "res://assets/character_ass/flip.png")
	animated_sprite.play("roll")

func is_roll_available() -> bool:
	return is_roll_allowed() 

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(global_variable.hp)
	file.store_var(position.x)
	file.store_var(position.y)
	file.store_var(inventoryPlaceholder)
	file.close()
func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		
		global_variable.hp = file.get_var(global_variable.hp)
		position.x = file.get_var(position.x)
		position.y = file.get_var(position.y)
		#inventoryPlaceholder = file.get_var(inventoryPlaceholder)

	
		file.close()
