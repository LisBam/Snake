extends Snale_base

@export var change_dir_time = 2.0  # 每隔2秒换一次方向
var move_dir: Vector2 = Vector2.RIGHT  # 初始移动方向
var dir_timer: float = 0.0  # 方向切换计时器

var view_distance: float = 600.0  # 视野距离
var avoidance_distance: float = 200.0  # 避障距离
var wall_avoidance_strength: float = 5.0  # 避开墙壁的强度
var snake_avoidance_strength: float = 1.5  # 避开其他蛇的强度

# 新增目标锁定变量
var current_target: Node2D = null  # 当前锁定的食物目标
var target_lock_time: float = 0.0  # 目标锁定时间
var min_lock_time: float = 1.5    # 最小锁定时间（秒）

func _physics_process(delta):
	super._physics_process(delta)
	
	# 1. 收集环境信息
	var foods = get_foods_in_view()
	var snakes = get_snakes_in_view()
	var walls = get_walls_in_view()
	
	# 2. 目标管理：更新锁定目标
	target_lock_time += delta
	
	# 如果当前目标无效或锁定时间结束，重新选择目标
	if !current_target or !is_instance_valid(current_target) or target_lock_time >= min_lock_time:
		if foods.size() > 0:
			current_target = foods[randi() % foods.size()]  # 随机选择一个新目标
			target_lock_time = 0.0
		else:
			current_target = null
	
	# 3. 计算目标方向
	var target_dir = Vector2.ZERO
	
	# 朝锁定的食物目标移动
	if current_target and is_instance_valid(current_target):
		target_dir += (current_target.global_position - global_position).normalized()
	
	# 避开其他蛇（保持不变）
	for snake in snakes:
		if snake != self:
			var dist = global_position.distance_to(snake.global_position)
			if dist < avoidance_distance:
				var avoid_dir = (global_position - snake.global_position).normalized()
				target_dir += avoid_dir * snake_avoidance_strength * (1.0 - dist/avoidance_distance)
	
	# 避开地图边界（保持不变）
	for wall in walls:
		var dist = global_position.distance_to(wall.global_position)
		if dist < avoidance_distance:
			var avoid_dir = (global_position - wall.global_position).normalized()
			target_dir += avoid_dir * wall_avoidance_strength * (1.0 - dist/avoidance_distance)
	
	# 4. 如果没有目标，随机移动（保持不变）
	if target_dir == Vector2.ZERO:
		dir_timer += delta
		if dir_timer >= change_dir_time:
			move_dir = Vector2(randf() - 0.5, randf() - 0.5).normalized()
			dir_timer = 0.0
	else:
		move_dir = target_dir.normalized()
	
	# 5. 移动（保持不变）
	velocity = move_dir * speed
	move_and_slide()

# 获取视野范围内的食物
func get_foods_in_view() -> Array:
	var foods_in_view = []
	for food in get_tree().get_nodes_in_group("food"):
		if not is_instance_valid(food): continue
		var dist = global_position.distance_to(food.global_position)
		if dist < view_distance:
			foods_in_view.append(food)
	return foods_in_view

# 获取视野范围内的蛇（包括玩家和其他敌人）
func get_snakes_in_view() -> Array:
	var snakes_in_view = []
	# 收集所有蛇（玩家和敌人）
	var all_snakes = get_tree().get_nodes_in_group("player") + get_tree().get_nodes_in_group("enemy")
	for snake in all_snakes:
		if not is_instance_valid(snake): continue
		var dist = global_position.distance_to(snake.global_position)
		if dist < view_distance:
			snakes_in_view.append(snake)
	return snakes_in_view

# 获取视野范围内的墙壁
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
