extends Episode

var key:bool = false


func _on_Key_enter():
	key = true


func _on_KeyHole_enter():
	if key:
		complete = true
		State.emit_signal("video_completed")
