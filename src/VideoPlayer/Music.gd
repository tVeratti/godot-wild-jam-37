extends Node2D

const VOLUME_THRESHOLD = 1

onready var Base:AudioStreamPlayer = $Base
onready var Top:AudioStreamPlayer = $Top
onready var Anim:AnimationPlayer = $AnimationPlayer

var base_start_time:float = 0.0
var base_duration:float = 21.0

func _ready():
	State.timeline.connect("paused", self, "_on_paused")
	State.timeline.connect("played", self, "_on_played")
	State.timeline.connect("playback_speed_changed", self, "_on_playback_speed_changed")
	
	Base.play()
	base_start_time = OS.get_ticks_msec()
	
	if State.timeline.playing:
		_on_played()


func _process(delta):
	var progress = max(0.001, State.timeline.timestamp)
	var diff = 0.0
	if progress < VOLUME_THRESHOLD:
		diff = progress
	elif progress > State.timeline.duration - VOLUME_THRESHOLD:
		diff = State.timeline.duration - progress
	
	if diff > 0.0:
		var reduction = (VOLUME_THRESHOLD / diff) * -20
#		Top.volume_db = 1 + reduction
	
	print(diff,  ' / ',Top.volume_db)
	
	if State.timeline.playing and not Top.playing:
		_on_played()
	elif not State.timeline.playing and Top.playing:
		_on_paused()


func _on_played():
	print("music played")
	# Line up the top music to the base
	Top.play(Base.get_playback_position())


func _on_paused():
	print("music paused")
	Top.stop()


func _on_playback_speed_changed():
	var pitch = max(0.75, State.timeline.playback_speed)
	Top.pitch_scale = pitch
	Base.pitch_scale = pitch
