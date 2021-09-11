extends Area2D


signal pressed()


var character_within_area:bool = false


func _process(delta):
	if Input.is_action_just_pressed("action") and character_within_area:
		emit_signal("pressed")


func _on_Button_body_entered(body):
	character_within_area = true


func _on_Button_body_exited(body):
	character_within_area = false
