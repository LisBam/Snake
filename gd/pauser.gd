extends Node

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		$"../pauseUI/black".visible = not $"../pauseUI/black".visible
		
