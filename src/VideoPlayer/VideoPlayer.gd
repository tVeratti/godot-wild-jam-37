extends Node2D

const WIDTH = 1280.0

export(NodePath) var timeline_path
onready var Timeline = get_node(timeline_path)

export(NodePath) var knob_path
onready var Knob = get_node(knob_path)

onready var Timestamp = $Timestamp

var knob_dragging:bool = false


func _process(delta):
	if knob_dragging:
		var player_progress = State.player.position.x / WIDTH
		State.timeline.set_progress(player_progress)
	
	var progress = State.timeline.progress 
	Timeline.value = progress 
	Knob.position.x = ((progress / 100) * WIDTH) - 20
	Timestamp.text = String(stepify(State.timeline.timestamp, 0.01))


func _on_Play_pressed():
	State.timeline.play()


func _on_Pause_pressed():
	State.timeline.pause()


func _on_Knob_pressed():
	knob_dragging = !knob_dragging
	if knob_dragging:
		State.player.fixed_y = Knob.position.y
	else:
		State.player.fixed_y = 0.0
