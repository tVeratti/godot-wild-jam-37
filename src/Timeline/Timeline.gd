extends Node


class_name Timeline

signal played()
signal paused()
signal timestamp_changed()
signal playback_speed_changed()


var entities:Array = []

var timestamp:float = 0.0
var duration:float = 100.0
var playback_speed:float = 1.0

var progress:float = 0.0 setget , _get_progress
var playing:bool setget , _get_playing

enum States { PLAYING, PAUSED }
var state:int = States.PLAYING


func _process(delta):
	if self.playing:
		timestamp += 1 * delta
	timestamp = clamp(timestamp, 0, duration)


func play():
	_toggle_play()


func pause():
	_toggle_play()


func set_progress(value):
	set_timestamp(duration * value)


func set_timestamp(value):
	state = States.PAUSED
	timestamp = clamp(value, 0, duration)
	emit_signal("timestamp_changed")


func set_playback_speed(value):
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
