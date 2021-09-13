extends Episode


var key:bool = false


func _on_Key_enter():
	key = true
	$Key.destroy()


func _on_Chest_enter():
	if key:
		$Chest.destroy()
		complete = true
