extends Node2D
var player_scene = load("uid://dbttwvffb8o36")
var player = player_scene.instantiate()

func _ready() -> void:
	pass
	add_child(player)
