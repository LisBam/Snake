extends Snale_base

func _physics_process(delta):
	super._physics_process(delta)
	
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
	get_tree().paused = true

func auto_adjust_zoom():
	var zoom_x = 1.0 - clamp((score - 200.0) / (2000.0 - 200.0), 0.0, 1.0) * 0.5
	var zoom_y = zoom_x
	$Camera2D.zoom=Vector2(zoom_x,zoom_y)
