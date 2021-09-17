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
onready var TimelineRoot = $Video/Timeline
onready var VideoEntities:Node2D = $VideoEntities

onready var NextButton = $Video/Timeline/Controls/NextButton

onready var Labels = $Video/Timeline/Labels
onready var Title:Label = $Video/Timeline/Labels/HBoxContainer/Title
onready var Number:Label = $Video/Timeline/Labels/HBoxContainer/Number
onready var Episode:Label = $Video/Timeline/Labels/HBoxContainer/Episode
onready var LabelsCollision:CollisionPolygon2D = $Video/Timeline/Labels/StaticBody2D/CollisionPolygon2D

var current_video

var knob_dragging:bool = false


func _ready():
	State.video_player = self
	
	State.timeline.connect("paused", self, "_on_paused")
	State.timeline.connect("played", self, "_on_played")
	State.timeline.connect("finished", self, "_on_finished")
	State.connect("video_completed", self, "_on_completed")
	State.connect("video_changed", self, "_on_video_changed")
	
	get_tree().get_root().connect("size_changed", self, "_on_size_changed")


func _process(delta):
	var bar_width = TimelineBar.rect_size.x
	var bar_offset = TimelineBar.rect_position.x
	var knob_width = Knob.width

	if knob_dragging:
		var player_progress = (State.player.position.x - TimelineRoot.position.x) / bar_width
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
	current_video.visible = false
	VideoEntities.add_child(current_video)
	
	if path == "E01":
		PlayButton.focus()
	
	if not current_video.complete: NextButton.disable()
	else: NextButton.enable()
	
	State.emit_signal("video_changed", current_video)
	
	update_positions()


func update_positions():
	pass
#	var size = OS.get_window_size()
#
#	var video_position = (size.y - 720) / 2
#	VideoEntities.position.y = video_position


func _on_PlayButton_pressed():
	State.timeline.toggle_play()


func _on_played():
	PlayButton.texture = pause_texture


func _on_paused():
	PlayButton.texture = play_texture


func _on_finished():
	if current_video.complete:
		NextButton.focus()
	

func _on_Knob_pressed():
	knob_dragging = !knob_dragging
	if knob_dragging:
		# Attach
		State.player.fixed_y = Knob.get_global_transform().origin.y - 10
		State.player.max_x = TimelineRoot.position.x + TimelineBar.rect_size.x
		State.player.min_x = TimelineRoot.position.x
	else:
		# Detach
		State.player.fixed_y = 0.0
		State.player.max_x = 0.0
		State.player.min_x = 0.0
		State.player.jump()


func _on_SpeedButton_pressed():
	State.timeline.toggle_playback_speed()


func _on_RewindButton_pressed():
	State.timeline.rewind()


func _on_ForwardButton_pressed():
	State.timeline.forward()


func _on_NextButton_pressed():
	if current_video.complete:
		State.next()


func _on_PreviousButton_pressed():
	State.previous()


func _on_video_changed(video):
	Number.text = "S37:%s" % video.title
	Episode.text = video.episode
	
	yield(get_tree(),"idle_frame")
	var size = Labels.rect_size
	LabelsCollision.polygon = PoolVector2Array([
		Vector2(0, 0),
		Vector2(size.x, 0),
		Vector2(size.x, 10),
		Vector2(0, 10),
	])



func _on_completed():
	NextButton.enable()
	NextButton.focus()


func _on_size_changed():
	update_positions()



