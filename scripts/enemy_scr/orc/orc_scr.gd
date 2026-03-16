extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

var Goal: Node2D = null  # будет найден в _ready
var distance_attack: int = 131
var hp: float = 10
var movement_speed: float = 500.0
var attack_scene = preload("res://scenes/enemy/orc/combat/attack_orc.tscn")
var attack_scene_down = preload("res://scenes/enemy/orc/combat/attack_orc_y.tscn")
var he_is_atack: bool = false

func _ready() -> void:
	# Находим игрока по группе "player"
	Goal = get_tree().get_first_node_in_group("player")
	if Goal == null:
		push_error("Player not found! Add the player node to the group 'player'.")

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(_delta):
	if he_is_atack:
		movement_speed = 0
	else:
		movement_speed = 100

	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
	if safe_velocity.x > 0:
		animated_sprite.flip_h = false
	elif safe_velocity.x < 0:
		animated_sprite.flip_h = true

func _process(_delta):
	if Goal == null:
		return
	create_temporary_area()
	if hp <= 0:
		queue_free()

func create_temporary_area():
	if global_position.distance_to(Goal.global_position) <= distance_attack and !he_is_atack:
		he_is_atack = true
		var direction = (Goal.global_position - global_position).normalized()
		var area_instance
		if abs(direction.x) > abs(direction.y):
			area_instance = attack_scene.instantiate()
			area_instance.scale.x = sign(direction.x)
		else:
			area_instance = attack_scene_down.instantiate()
			area_instance.scale.y = sign(direction.y)

		add_child(area_instance)
		await area_instance.tree_exited
		he_is_atack = false

func _on_timer_timeout() -> void:
	if Goal != null:
		set_movement_target(Goal.global_position)
