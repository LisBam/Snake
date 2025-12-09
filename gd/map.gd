extends Node2D
var player_scene = load("uid://dbttwvffb8o36")
var enemy_scene = load("uid://ckwuwc7b26dbb")
var player = player_scene.instantiate()

@export var food_scene: PackedScene 
@export var max_food = 220
@export var spawn_interval = 0.05 

var food_list = []
var timer = 0.0

var max_enemy:int = 6
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

func spawn_initial_food():
	for i in range(max_food):
		spawn_one_food()


func spawn_one_food():
	var new_food = food_scene.instantiate()
	
	var valid_pos = false
	while not valid_pos:
		new_food.position = Vector2(
			randf_range(-4950, 4950),
			randf_range(-4950, 4950)
		)

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
	
	var random_offset_range = 5.0

	var random_x = randf_range(-random_offset_range, random_offset_range)
	var random_y = randf_range(-random_offset_range, random_offset_range)
	

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
