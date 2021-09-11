extends Node


static func format_seconds(seconds:float):
	var minutes = seconds / 60.0
	var seconds_left = fposmod(seconds, 60.0)
	return "%02d:%02d" % [minutes, seconds_left]
