extends Snale_base

func _physics_process(delta):
	super._physics_process(delta)
	
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
