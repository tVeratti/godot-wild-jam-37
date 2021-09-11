extends Node2D


signal pressed()


export(Texture) var texture:Texture setget _set_texture
var _texture:Texture

onready var ButtonSprite:Sprite = $PressArea/Sprite

var width = 0


var character_within_area:bool = false

func _ready():
	if _texture != null:
		self.texture = _texture
	
	width = ButtonSprite.texture.get_width()


func _process(delta):
	if Input.is_action_just_pressed("action") and character_within_area:
		emit_signal("pressed")


func _set_texture(value):
	_texture = value
	if is_instance_valid(ButtonSprite):
		ButtonSprite.texture = value


func _set_collision(value):
	_texture = value
	if is_instance_valid(ButtonSprite):
		ButtonSprite.texture = value



func _on_PressArea_body_entered(body):
	if body is KinematicBody2D:
		character_within_area = true


func _on_PressArea_body_exited(body):
	if body is KinematicBody2D:
		character_within_area = false
