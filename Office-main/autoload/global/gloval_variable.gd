extends Node

# - Конфигурация
# - Статы Перса
var speed: float =  500.0 
var hp: float =  100.0 
var damage: float = 5.0;

var crit_damage: float  = 1.5
var crit_chache: int  = 10

# - Кувырок
var roll_duration: float = 0.4  
var roll_cooldown: float = 1.5
var roll_speed: float = 1500.0 


# - Это не меняйте
var max_value: float  = 100.0;
var min_value: float  = 0.0;
var he_is_atack: bool = false
var im_Dead: bool = false
var is_rolling: bool = false
var roll_cooldown_timer: float
