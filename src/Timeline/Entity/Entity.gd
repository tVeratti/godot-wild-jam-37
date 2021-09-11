extends Node2D

onready var VideoAnimations = $VideoAnimations


func _ready():
	VideoAnimations.play("main_video")


func _process(delta):
	VideoAnimations.seek(State.timeline.timestamp, true)
