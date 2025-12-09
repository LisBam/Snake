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


func _on_replay_button_up() -> void:
	_on_continue_button_up()
	var current_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_path)


func _on_out_button_up() -> void:
	get_tree().quit()
