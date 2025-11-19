extends CharacterBody2D

@export var speed = 500.0

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	velocity = direction * speed
	move_and_slide()
