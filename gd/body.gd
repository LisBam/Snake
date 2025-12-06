extends CharacterBody2D

var leader: Node2D
@export var follow_distance: float = 40.0
@export var speed: float = 500.0

var is_dash:bool = false
var dash_mul:float = 1.8

func _physics_process(delta):
	if leader == null:
		printerr("no leader!!!!")
		return

	var direction = (leader.global_position - global_position).normalized()
	
	var distance = global_position.distance_to(leader.global_position)
	
	if distance > follow_distance:
		if is_dash:
			velocity = direction * speed * dash_mul
		else:
			velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
