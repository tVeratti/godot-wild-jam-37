extends Node

signal video_changed(video)
signal video_completed()

var timeline:Timeline = Timeline.new()

const VIDEOS = [
	"E01",
	"E02"
]

var video_player
var video_index:int = -1
var player


func _ready():
	add_child(timeline)


func next():
	video_index += 1
	if video_index >= VIDEOS.size():
		video_index = 0
	
	video_player.set_video(VIDEOS[video_index])


func previous():
	if timeline.timestamp < 3:
		if video_index > 0:
			video_index -= 1
	
		video_player.set_video(VIDEOS[video_index])
	else:
		timeline.set_timestamp(0.0)
