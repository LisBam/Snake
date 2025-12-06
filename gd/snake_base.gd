class_name Snale_base extends CharacterBody2D

@export var base_speed = 500.0
@export var speed = base_speed
@export var body_count : int = 4
@export var score:int = 200
@export var is_player:bool = true

var is_dash:bool = false
var dash_mul:float = 1.8

const body_scene = preload("uid://co7ngk5h1j3c6")
var bodys: Array[CharacterBody2D] = []

func _ready() -> void:
	speed = base_speed
	print("snake ready func!")
	add_body(body_count)
	
func _physics_process(delta):
	if (bodys.size()!=score/50):
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
