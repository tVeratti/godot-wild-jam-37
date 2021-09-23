extends Episode

# EPISODE 01

func _ready():
	autoplay = false
	complete = true
	
	if not State.timeline.playing:
		State.emit_signal("focus_play")



