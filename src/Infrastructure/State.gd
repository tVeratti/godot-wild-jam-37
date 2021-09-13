extends Node

signal video_changed(video)


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
	video_player.set_video(VIDEOS[video_index])
