extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var player_hitbox = $Area2D

var movement = movement_vector()
var direction = movement.normalized()
var attack_x_scene = preload("res://scenes/main_character/combat/attack_base.tscn")
var attack_y_scene = preload("res://scenes/main_character/combat/attack_base_y.tscn")


var roll_timer: float
var roll_direction = Vector2.ZERO
var can_roll = true  
var prevHP = global_variable.hp

func _ready():
	global_variable.is_rolling = false
	global_variable.he_is_atack = false


func can_move() -> bool:
	return !global_variable.he_is_atack and !global_variable.im_Dead

func can_attack() -> bool:
	return !global_variable.he_is_atack and !global_variable.im_Dead and !global_variable.is_rolling

func is_roll_allowed() -> bool:
	return can_roll and !global_variable.is_rolling and can_attack()

func _process(delta):
	if !can_roll:
		global_variable.roll_cooldown_timer -= delta  
		if global_variable.roll_cooldown_timer <= 0:
			can_roll = true
	
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
		add_child(area_instance)

func start_roll():
	if !is_roll_allowed():
		return
	
	global_variable.is_rolling = true
	can_roll = false
	roll_timer = global_variable.roll_duration
	global_variable.roll_cooldown_timer = global_variable.roll_cooldown
	
	if direction != Vector2.ZERO:
		roll_direction = direction
	else:
		roll_direction = Vector2.RIGHT if !animated_sprite.flip_h else Vector2.LEFT
	
	animated_sprite.play("roll")

func is_roll_available() -> bool:
	return is_roll_allowed() 

func get_roll_cooldown_progress() -> float:
	if can_roll:
		return 1.0
	else:
		return 1.0 - (global_variable.roll_cooldown_timer / global_variable.roll_cooldown)
