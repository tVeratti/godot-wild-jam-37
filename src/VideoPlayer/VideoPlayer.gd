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

onready var Title:Label = $Labels/HBoxContainer/Title
onready var Number:Label = $Labels/HBoxContainer/Number
onready var Episode:Label = $Labels/HBoxContainer/Episode

var current_video

var knob_dragging:bool = false


func _ready():
	State.video_player = self
	
	State.timeline.connect("paused", self, "_on_paused")
	State.timeline.connect("played", self, "_on_played")
	State.connect("video_changed", self, "_on_video_changed")
	
	_on_played()
	
	State.next()


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
	
	# Text values
	Timestamp.text = String(stepify(State.timeline.timestamp, 0.01))
	TimeLeft.text = Time.format_seconds(State.timeline.duration - State.timeline.timestamp)


func set_video(path):
	if is_instance_valid(current_video):
		current_video.queue_free()
	
	var Episode = load("res://Videos/%s/%s.tscn" % [path, path])
	current_video = Episode.instance()
	current_video.position.y = 150
	current_video.visible = false
	add_child(current_video)
	State.emit_signal("video_changed", current_video)


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


func _on_NextButton_pressed():
#	if current_video.complete:
	State.next()


func _on_video_changed(video):
	Number.text = "S36:%s" % video.name
	Episode.text = video.episode
