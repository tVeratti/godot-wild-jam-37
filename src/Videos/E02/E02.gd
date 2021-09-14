extends Episode

var key:bool = false


func _on_Key_enter():
	key = true
	$Key.destroy()


func _on_KeyHoleEntity_enter():
	if key:
		$KeyHoleEntity.destroy()
		complete = true
