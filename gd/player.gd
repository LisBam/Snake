extends CharacterBody2D

@export var base_speed = 500.0
@export var speed = base_speed
@export var body_count : int = 3

var is_dash:bool = false

var body_scene = preload("uid://co7ngk5h1j3c6")
var bodys: Array[CharacterBody2D] = []

func _ready() -> void:
	speed = base_speed

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	if is_dash:
		velocity = direction * speed * 1.5
	else:
		velocity = direction * speed
	move_and_slide()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_dash = true
	else:
		is_dash = false
