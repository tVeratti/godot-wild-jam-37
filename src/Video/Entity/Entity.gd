extends Node2D

signal action()
signal enter()

onready var VideoAnimations = $AnimationPlayer
onready var EntitySprie:Sprite = $Sprite



var player_within:bool = false


func _ready():
	VideoAnimations.play("main")


func _process(delta):
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
