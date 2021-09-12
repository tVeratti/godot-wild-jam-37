extends Node2D

class_name Entity

const MAIN_ANIMATION_NAME = "main"

signal action()
signal enter()

onready var VideoAnimations:AnimationPlayer = $AnimationPlayer
var EntitySprite:Sprite


var player_within:bool = false


func _ready():
	if has_node("Sprite"):
		EntitySprite = $Sprite
	
	if is_instance_valid(VideoAnimations) and VideoAnimations.has_animation(MAIN_ANIMATION_NAME):
		VideoAnimations.play(MAIN_ANIMATION_NAME)


func _process(delta):
	if is_instance_valid(VideoAnimations):
		if VideoAnimations.is_playing():
			VideoAnimations.seek(State.timeline.timestamp, true)
		
	if Input.is_action_just_pressed("action") and player_within:
		emit_signal("action")


func destroy():
	queue_free()


func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		player_within = true
		emit_signal("enter")


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		player_within = false
