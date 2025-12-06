extends Snale_base

@export var change_dir_time = 2.0  # 每隔2秒换一次方向
var move_dir: Vector2 = Vector2.RIGHT  # 初始移动方向
var dir_timer: float = 0.0  # 方向切换计时器

func _physics_process(delta):
	# 1. 计时：到时间就随机换方向
	dir_timer += delta
	if dir_timer >= change_dir_time:
		# 生成随机方向（上下左右随机）
		move_dir = Vector2(randf() - 0.5, randf() - 0.5).normalized()
		dir_timer = 0.0  # 重置计时器
	
	# 2. 设置移动速度并移动
	velocity = move_dir * speed
	move_and_slide()
