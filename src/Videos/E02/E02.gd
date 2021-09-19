extends Episode

# EPISODE 02

var key:bool = false


onready var Unlock = $Unlock


func _on_finished():
	if not complete:
		State.emit_signal("focus_knob")


func _on_Key_enter():
	key = true
	Unlock.enable()
	Unlock.label = "Unlock next episode"


func _on_Unlock_enter():
	if key:
		complete = true
		State.emit_signal("video_completed")
