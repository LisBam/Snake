extends Node

var max_scores = 10

const save_location = "user://SaveFile.json"

var save_contents : Dictionary = {
	"max_scores" : 200,
}

func _ready() -> void:
	_load()

func _save():
	save_contents.max_scores = max_scores
	var file = FileAccess.open(save_location,FileAccess.WRITE)
	file.store_var(save_contents.duplicate())
	file.close()
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location,FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		save_contents.max_scores = save_data.max_scores
	else:
		printerr("数据不存在！！！")
	max_scores = save_contents.max_scores
