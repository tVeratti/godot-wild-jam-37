extends Node2D


func _ready():
	$AnimationPlayer.play("blink")


func _input(event):
	if Input.is_action_just_pressed("action"):
		queue_free()
		State.next()
