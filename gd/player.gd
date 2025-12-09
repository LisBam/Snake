extends Snale_base

var respawn_times:int = 0

func _physics_process(delta):
	super._physics_process(delta)
	
	if not is_dying:
		auto_adjust_zoom()
		
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		
		if is_dash:
			velocity = direction * speed * dash_mul
		else:
			velocity = direction * speed
		move_and_slide()
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dash()
		else:
			undash()

func add_body(count:int):
	super.add_body(count)
	
	add_to_group("player")
	for body in bodys:
		for area2d in body.get_children():
			if area2d is Area2D:
				area2d.add_to_group("player")

func die():
	super.die()
	$die_ui.visible = true
	is_dying = true
	begin_time_to_respawn(5)
	score = 0

func auto_adjust_zoom():
	var zoom_x = 1.0 - clamp((score - 200.0) / (2000.0 - 200.0), 0.0, 1.0) * 0.5
	var zoom_y = zoom_x
	$Camera2D.zoom=Vector2(zoom_x,zoom_y)

func begin_time_to_respawn(time:int):
	respawn_times = time
	$die_ui/Label.text = str(respawn_times)
	while respawn_times > 0:
		await get_tree().create_timer(1.0).timeout
		respawn_times -= 1
		$die_ui/Label.text = str(respawn_times)
	is_dying = false
	$Sprite2D.visible = true
	$die_ui.visible = false
	position = Vector2(0,0)
	score = 200
	
