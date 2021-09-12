extends Node2D

export(Texture) var play_texture
export(Texture) var pause_texture

export(NodePath) var timeline_path
onready var TimelineBar:ProgressBar = get_node(timeline_path)

export(NodePath) var knob_path
onready var Knob = get_node(knob_path)

export(NodePath) var play_button_path
onready var PlayButton = get_node(play_button_path)

onready var Timestamp = $Timestamp
onready var TimeLeft = $Video/Timeline/TimeLeft

var knob_dragging:bool = false


func _ready():
	State.timeline.connect("paused", self, "_on_paused")
	State.timeline.connect("played", self, "_on_played")
	
	_on_played()


func _process(delta):
	var bar_width = TimelineBar.rect_size.x
	var bar_offset = TimelineBar.rect_position.x
	var knob_width = Knob.width

	if knob_dragging:
		var player_progress = State.player.position.x / bar_width
		State.timeline.set_progress(player_progress)
	
	var progress = State.timeline.progress 
	TimelineBar.value = progress
	
	Knob.position.x = ((progress / 100) * bar_width) - bar_offset - (knob_width / 2)
	Timestamp.text = String(stepify(State.timeline.timestamp, 0.01))
	TimeLeft.text = Time.format_seconds(State.timeline.duration - State.timeline.timestamp)


func _on_PlayButton_pressed():
	State.timeline.play()


func _on_played():
	PlayButton.texture = pause_texture


func _on_paused():
	PlayButton.texture = play_texture


func _on_Knob_pressed():
	knob_dragging = !knob_dragging
	if knob_dragging:
		State.player.fixed_y = Knob.get_global_transform().origin.y - 10
		State.player.max_x = TimelineBar.rect_position.x + TimelineBar.rect_size.x
	else:
		State.player.fixed_y = 0.0
		State.player.jump()


func _on_SpeedButton_pressed():
	State.timeline.toggle_playback_speed()


func _on_RewindButton_pressed():
	State.timeline.rewind()


func _on_ForwardButton_pressed():
	State.timeline.forward()
