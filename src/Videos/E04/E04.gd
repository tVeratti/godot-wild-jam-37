extends Episode

# EPISODE 03

var key:bool = false

onready var Unlock = $Unlock


func _on_Key_enter():
	key = true
	Unlock.enable()


func _on_Unlock_enter():
	if key:
		complete = true
		State.emit_signal("video_completed")
