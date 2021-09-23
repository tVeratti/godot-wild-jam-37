extends Entity

export(String) var label:String = "" setget _set_label
export(AudioStream) var audio:AudioStream setget _set_audio

onready var SpriteLabel:Label = $Sprite/Label
onready var YoinkAnimation:AnimationPlayer = $YoinkAnimation
onready var YoinkSound:AudioStreamPlayer = $YoinkSound

export(bool) var disabled:bool = false
export(String) var yoink_signal:String = "key_yoinked"


func _ready():
	_set_label(label)
	_set_audio(audio)
	
	$YoinkCircle.texture = sprite_texture


func enable():
	disabled = false


func _on_Area2D_body_entered(body):
	if body is KinematicBody2D and not disabled:
		player_within = true
		YoinkAnimation.play("yoink")
		YoinkSound.play()
		emit_signal("enter")
		State.emit_signal(yoink_signal)


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		player_within = false


func _on_YoinkAnimation_animation_finished(anim_name):
	if anim_name == "yoink":
		queue_free()


func _set_label(value):
	label = value
	if is_instance_valid(SpriteLabel):
		SpriteLabel.text = value


func _set_audio(value):
	audio = value
	if is_instance_valid(YoinkSound):
		YoinkSound.stream = value
