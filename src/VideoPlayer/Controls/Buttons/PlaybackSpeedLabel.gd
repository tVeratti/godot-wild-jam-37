extends Label



# Called when the node enters the scene tree for the first time.
func _ready():
	State.timeline.connect("playback_speed_changed", self, "_on_playback_speed_changed")
	
func _on_playback_speed_changed():
	text = "%sx" % State.timeline.playback_speed
