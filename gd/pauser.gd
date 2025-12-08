extends Node

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		$"../pauseUI/black".visible = not $"../pauseUI/black".visible
		$"../pauseUI/pauseUI".visible = not $"../pauseUI/pauseUI".visible


func _on_continue_button_up() -> void:
	get_tree().paused = not get_tree().paused
	$"../pauseUI/black".visible = not $"../pauseUI/black".visible
	$"../pauseUI/pauseUI".visible = not $"../pauseUI/pauseUI".visible
