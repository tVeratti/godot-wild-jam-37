extends Episode

var key:bool = false



func _ready():
	._ready()
		
	State.timeline.connect("finished", self, "_on_finished")


func _on_finished():
	if not complete:
		State.emit_signal("focus_knob")


func _on_Key_enter():
	key = true


func _on_KeyHole_enter():
	if key:
		complete = true
		State.emit_signal("video_completed")
