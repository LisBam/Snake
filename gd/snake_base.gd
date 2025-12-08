class_name Snale_base extends CharacterBody2D

@export var base_speed = 500.0
@export var speed = base_speed
@export var body_count : int = 4
@export var score:int = 200
@export var is_player:bool = true

var is_dash:bool = false
var dash_mul:float = 1.8
var is_die:bool = false

const body_scene = preload("uid://co7ngk5h1j3c6")
var bodys: Array[CharacterBody2D] = []

func _ready() -> void:
	speed = base_speed
	print("snake ready func!")
	add_body(body_count)
	
func _physics_process(delta):
	if (bodys.size()!=score/50 and not is_die):
		print("body count should refresh!")
		if(bodys.size()<score/50):
			add_body(score/50-bodys.size())
		else:
			remove_body(bodys.size()-score/50)
	
func _area_entered(area: Area2D) -> void:
	#print("entered is ",area)
	if(area.is_in_group("food")):
		print("food entered!")
		area.get_parent().queue_free()
		change_score(10)
		if $audio/pick:
			$audio/pick.play()
			
	if(area.is_in_group("wall")):
		die()
	if(not is_player and (area.is_in_group("player"))):
		die()
	if(is_player and area.is_in_group("enemy")):
		die()

func add_body(count:int):
	print("func add_body with ",count)
	for i in range(count):
		var body = body_scene.instantiate()
		if bodys.size() > 0:
			body.global_position = bodys[-1].global_position
		else:
			body.global_position = self.global_position
		
		add_sibling(body)
		if bodys:
			body.leader = bodys[-1]
		else:
			body.leader = self
		bodys.append(body)
	print("add body！now size is ", bodys.size())

func remove_body(count:int):
	print("func remove_body with ",count)
	for i in range(count):
		if bodys.size() <= body_count:
			printerr("bodys size is long than count")
			return
		bodys.pop_back().queue_free()
	print("remove body！now size is ", bodys.size())

func change_score(count:int):
	score += count
	print("change score with ",count,"!now score is ",score)

func dash():
	is_dash = true
	for i in bodys:
		i.is_dash = true
		i.dash_mul = dash_mul
func undash():
	is_dash = false
	for i in bodys:
		i.is_dash = false

func die():
	is_die = true
	get_tree().current_scene.curr_enemy_count -= 1
	
	var snake_positions = []
	
	snake_positions.append(global_position)
	
	for body in bodys:
		snake_positions.append(body.global_position)
	
	for body in bodys:
		body.queue_free()
	bodys.clear()
	
	if is_player:
		for child in get_children():
			if child is Sprite2D:
				child.queue_free()
	else:
		queue_free()
	
	var map = get_tree().current_scene
	if map:
		# 遍历蛇的所有位置，生成连续的食物线
		for i in range(snake_positions.size()):
			# 生成当前位置的食物
			map.spawn_food_at_point(snake_positions[i])
			
			# 如果不是最后一个位置，在当前位置和下一个位置之间生成中间食物
			if i < snake_positions.size() - 1:
				var current_pos = snake_positions[i]
				var next_pos = snake_positions[i + 1]
				# 计算两个位置的中点
				var mid_pos = (current_pos + next_pos) / 2
				# 生成中间位置的食物
				map.spawn_food_at_point(mid_pos)
