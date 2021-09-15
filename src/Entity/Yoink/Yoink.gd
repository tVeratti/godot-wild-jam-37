extends Entity


onready var YoinkAnimation:AnimationPlayer = $YoinkAnimation


func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		player_within = true
		YoinkAnimation.play("yoink")
		emit_signal("enter")


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		player_within = false


func _on_YoinkAnimation_animation_finished(anim_name):
	if anim_name == "yoink":
		queue_free()
