extends CharacterBody2D

var leader: Node2D
@export var follow_distance: float = 20.0  # 跟随距离
@export var follow_speed: float = 500.0    # 跟随速度

func _physics_process(delta):
	if leader == null:
		printerr("no leader!!!!")
		return
	
	# 计算指向领导者的方向
	var direction = (leader.global_position - global_position).normalized()
	
	# 如果距离太远，就靠近
	var distance = global_position.distance_to(leader.global_position)
	
	if distance > follow_distance:
		velocity = direction * follow_speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
