extends Node2D
var player_scene = load("uid://dbttwvffb8o36")
var enemy_scene = load("uid://ckwuwc7b26dbb")
var player = player_scene.instantiate()

@export var food_scene: PackedScene  # 拖拽食物场景到这里
@export var max_food = 220            # 最多同时存在的食物数量
@export var spawn_interval = 0.05    # 补充食物的间隔（秒）

var food_list = []  # 存储所有食物节点
var timer = 0.0     # 生成食物的计时器

var max_enemy:int = 10
var curr_enemy_count:int

func _ready() -> void:
	add_child(player)
	spawn_initial_food()
	for i in range(max_enemy):
		spawn_enemy()
	curr_enemy_count = max_enemy
	
func _physics_process(delta):
	if curr_enemy_count < max_enemy:
		print("curr_enemy is ",curr_enemy_count)
		print("max_enemy is ",max_enemy)
		spawn_enemy()
		curr_enemy_count += 1
	
	if food_list.size() < max_food:
		timer += delta
		if timer >= spawn_interval:
			spawn_one_food()
			timer = 0.0
			print("spawn food ! now food in the map is ",food_list.size())

# 开局生成满额食物
func spawn_initial_food():
	for i in range(max_food):
		spawn_one_food()


# 生成单个食物（确保不与玩家重合）
func spawn_one_food():
	var new_food = food_scene.instantiate()
	
	# 循环生成位置，直到不与玩家重合
	var valid_pos = false
	while not valid_pos:
		# 地图内随机位置
		new_food.position = Vector2(
			randf_range(-4950, 4950),
			randf_range(-4950, 4950)
		)
		# 检查是否与玩家重合（距离大于50则合法）
		if new_food.position.distance_to(player.position) > 50:
			valid_pos = true
	
	add_child(new_food)
	food_list.append(new_food)
	new_food.tree_exiting.connect(func():
		if new_food in food_list:
			food_list.erase(new_food)
	)
	
func spawn_food_at_point(point_position:Vector2):
	var new_food = food_scene.instantiate()
	
	# 定义随机偏差范围
	var random_offset_range = 5.0
	# 生成X和Y轴的随机偏差
	var random_x = randf_range(-random_offset_range, random_offset_range)
	var random_y = randf_range(-random_offset_range, random_offset_range)
	
	# 应用随机偏差到目标位置
	new_food.position = point_position + Vector2(random_x, random_y)
	
	add_child(new_food)
	#food_list.append(new_food)
	new_food.tree_exiting.connect(func():
		if new_food in food_list:
			food_list.erase(new_food)
	)

func spawn_enemy():
	var new_enemy = enemy_scene.instantiate()
	new_enemy.is_player = false
	
	var valid_pos = false
	while not valid_pos:
		new_enemy.position = Vector2(
			randf_range(-4950, 4950),
			randf_range(-4950, 4950)
		)
		if new_enemy.position.distance_to(player.position) > 1000:
			valid_pos = true
	
	add_child(new_enemy)
