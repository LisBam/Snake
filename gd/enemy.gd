extends Snale_base

@export var change_dir_time = 2.0  # 每隔2秒换一次方向
var move_dir: Vector2 = Vector2.RIGHT  # 初始移动方向
var dir_timer: float = 0.0  # 方向切换计时器

func _physics_process(delta):
	super._physics_process(delta)
	var nearest_food = null
	var min_dist = 3000  # 初始设一个很大的距离
	# 遍历所有食物，找最近的
	for food in get_tree().get_nodes_in_group("food"):
		if not is_instance_valid(food): continue  # 跳过无效节点
		var dist = global_position.distance_to(food.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest_food = food
	
	# 2. 有食物就朝最近的走，没食物就随机走
	if nearest_food:
		move_dir = (nearest_food.global_position - global_position).normalized()
	else:
		dir_timer += delta
		if dir_timer >= change_dir_time:
			move_dir = Vector2(randf() - 0.5, randf() - 0.5).normalized()
			dir_timer = 0.0
	
	# 3. 移动
	velocity = move_dir * speed
	move_and_slide()
