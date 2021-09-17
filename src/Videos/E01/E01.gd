extends Episode


func _ready():
	._ready()
	
	autoplay = false
	complete = true
	
	State.emit_signal("focus_play")


