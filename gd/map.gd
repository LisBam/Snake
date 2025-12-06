extends Node2D
var player_scene = load("uid://dbttwvffb8o36")
var enemy_scene = load("uid://ckwuwc7b26dbb")
var player = player_scene.instantiate()

@export var food_scene: PackedScene  # 拖拽食物场景到这里
@export var max_food = 200            # 最多同时存在的食物数量
@export var spawn_interval = 2.0    # 补充食物的间隔（秒）

var food_list = []  # 存储所有食物节点
var timer = 0.0     # 生成食物的计时器

func _ready() -> void:
	pass
	add_child(player)
	spawn_initial_food()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
	
func _physics_process(delta):
	# 检查食物数量，不足则计时补充
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
		if new_food.position.distance_to(player.position) > 100:
			valid_pos = true
	
	add_child(new_food)
	food_list.append(new_food)
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
		if new_enemy.position.distance_to(player.position) > 300:
			valid_pos = true
	
	add_child(new_enemy)
