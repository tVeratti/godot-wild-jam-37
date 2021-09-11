extends Node


var timeline:Timeline = Timeline.new()

var video_player
var player


func _ready():
	add_child(timeline)
