extends Node


class_name Timeline

signal played()
signal paused()
signal timestamp_changed()
signal playback_speed_changed()

const JUMP_SECONDS = 5


var timestamp:float = 0.0
var duration:float = 40.0
var playback_speed:float = 1.0

var progress:float = 0.0 setget , _get_progress
var playing:bool setget , _get_playing

enum States { PLAYING, PAUSED }
var state:int = States.PAUSED

func _ready():
	State.connect("video_changed", self, "_on_video_changed")


func _process(delta):
	if self.playing:
		timestamp += 1 * playback_speed * delta
	timestamp = clamp(timestamp, 0, duration)
	

func play():
	_toggle_play()


func pause():
	_toggle_play()


func rewind():
	set_timestamp(timestamp - JUMP_SECONDS)


func forward():
	set_timestamp(timestamp + JUMP_SECONDS)


func set_progress(value):
	set_timestamp(duration * value)


func set_timestamp(value):
	state = States.PAUSED
	timestamp = clamp(value, 0, duration)
	emit_signal("timestamp_changed")
	emit_signal("paused")


func toggle_playback_speed():
	if playback_speed == 1: playback_speed = 0.25
	else: playback_speed = 1
	emit_signal("playback_speed_changed")


func _toggle_play():
	if self.playing:
		state = States.PAUSED
		emit_signal("paused")
	else:
		state = States.PLAYING
		emit_signal("played")	


func _get_progress():
	return (timestamp / duration) * 100.0


func _get_playing():
	return state == States.PLAYING


func _on_video_changed(video):
	duration = video.duration
	set_timestamp(0.0)
