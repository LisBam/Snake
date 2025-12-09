extends Snale_base

@export var change_dir_time = 2.0
var move_dir: Vector2 = Vector2.RIGHT
var dir_timer: float = 0.0

var view_distance: float = 600.0
var avoidance_distance: float = 200.0 
var wall_avoidance_strength: float = 5.0
var snake_avoidance_strength: float = 1.5


var current_target: Node2D = null
var target_lock_time: float = 0.0
var min_lock_time: float = 1.5

func _physics_process(delta):
	super._physics_process(delta)

	var foods = get_foods_in_view()
	var snakes = get_snakes_in_view()
	var walls = get_walls_in_view()
	
	target_lock_time += delta
	
	if !current_target or !is_instance_valid(current_target) or target_lock_time >= min_lock_time:
		if foods.size() > 0:
			current_target = foods[randi() % foods.size()]  # 随机选择一个新目标
			target_lock_time = 0.0
		else:
			current_target = null
	
	var target_dir = Vector2.ZERO
	
	if current_target and is_instance_valid(current_target):
		target_dir += (current_target.global_position - global_position).normalized()
	
	for snake in snakes:
		if snake != self:
			var dist = global_position.distance_to(snake.global_position)
			if dist < avoidance_distance:
				var avoid_dir = (global_position - snake.global_position).normalized()
				target_dir += avoid_dir * snake_avoidance_strength * (1.0 - dist/avoidance_distance)
	
	for wall in walls:
		var dist = global_position.distance_to(wall.global_position)
		if dist < avoidance_distance:
			var avoid_dir = (global_position - wall.global_position).normalized()
			target_dir += avoid_dir * wall_avoidance_strength * (1.0 - dist/avoidance_distance)
	
	if target_dir == Vector2.ZERO:
		dir_timer += delta
		if dir_timer >= change_dir_time:
			move_dir = Vector2(randf() - 0.5, randf() - 0.5).normalized()
			dir_timer = 0.0
	else:
		move_dir = target_dir.normalized()
	
	velocity = move_dir * speed
	move_and_slide()

func get_foods_in_view() -> Array:
	var foods_in_view = []
	for food in get_tree().get_nodes_in_group("food"):
		if not is_instance_valid(food): continue
		var dist = global_position.distance_to(food.global_position)
		if dist < view_distance:
			foods_in_view.append(food)
	return foods_in_view

func get_snakes_in_view() -> Array:
	var snakes_in_view = []
	var all_snakes = get_tree().get_nodes_in_group("player") + get_tree().get_nodes_in_group("enemy")
	for snake in all_snakes:
		if not is_instance_valid(snake): continue
		var dist = global_position.distance_to(snake.global_position)
		if dist < view_distance:
			snakes_in_view.append(snake)
	return snakes_in_view

func get_walls_in_view() -> Array:
	var walls_in_view = []
	for wall in get_tree().get_nodes_in_group("wall"):
		if not is_instance_valid(wall): continue
		var dist = global_position.distance_to(wall.global_position)
		if dist < view_distance:
			walls_in_view.append(wall)
	return walls_in_view

func add_body(count:int):
	super.add_body(count)
	
	add_to_group("enemy")
	for body in bodys:
		for area2d in body.get_children():
			if area2d is Area2D:
				area2d.add_to_group("enemy")
