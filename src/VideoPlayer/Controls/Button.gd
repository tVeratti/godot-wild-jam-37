extends Node2D


signal pressed()


export(Texture) var texture:Texture setget _set_texture
var _texture:Texture

export(bool) var generate_collisions:bool = true

onready var ButtonSprite:Sprite = $PressArea/Sprite
onready var OutlineSprite:Sprite = $PressArea/Outline
onready var FocusSprite:Sprite = $Focus

onready var ClickSound:AudioStreamPlayer = $ClickSound

onready var ActionAnimation:AnimationPlayer = $ActionAnimation
onready var HoverAnimation:AnimationPlayer = $HoverAnimation
onready var FocusAnimation:AnimationPlayer = $FocusAnimation
onready var PlatformBody:StaticBody2D = $Platform

var width = 0
var disabled:bool = false
var character_within_area:bool = false


func _ready():
	State.connect("video_changed", self, "_on_video_changed")
	
	if _texture != null:
		self.texture = _texture
	
	OutlineSprite.visible = false
	FocusSprite.visible = false
	width = ButtonSprite.texture.get_width()
	
	FocusSprite.position = OutlineSprite.position


func _process(delta):
	if Input.is_action_just_pressed("action") and character_within_area:
		ClickSound.play()
		ActionAnimation.play("action")
		FocusSprite.visible = false
		FocusAnimation.stop()
		emit_signal("pressed")


func disable():
	disabled = true
	modulate = Color.dimgray
	OutlineSprite.visible = false
	FocusSprite.visible = false
	FocusAnimation.stop()


func enable():
	disabled = false
	modulate = Color.white


func focus():
	FocusSprite.visible = true
	FocusAnimation.play("focus")


func reset():
	FocusSprite.visible = false
	FocusAnimation.stop()


func _set_texture(value):
	_texture = value
	
	if is_instance_valid(ButtonSprite):
		ButtonSprite.texture = value
		
		if generate_collisions:
			# Generate the collision shape based on the texture bitmap
			var collision_shape = Shapes.create_collision_polygon(Vector2.ZERO, value)
			
			# Update/Add collision polygons
			var index = 1
			for polygon in collision_shape.polygons:
				_set_collision_shape("Platform/CollisionPolygon2D%s" % index, polygon)
				index += 1
			
			# Remove extra collision polygons
			while PlatformBody.get_child_count() > collision_shape.polygons.size():
				var node = PlatformBody.get_children().pop_back()
				PlatformBody.remove_child(node)


func _set_collision_shape(path:String, polygon:PoolVector2Array, scale_up:bool = false):
	var node:CollisionPolygon2D
	if has_node(path):
		node = get_node(path)
	else:
		node = CollisionPolygon2D.new()
		node.one_way_collision = true
		PlatformBody.add_child(node)
		
	node.set_polygon(polygon)
	
	if scale_up:
		node.scale = Vector2(1.2, 1.2)


func _on_video_changed(_video):
	reset()


func _on_PressArea_body_entered(body):
	if body is KinematicBody2D:
		if not disabled:
			character_within_area = true
			HoverAnimation.play("hover")


func _on_PressArea_body_exited(body):
	if body is KinematicBody2D:
#		FocusSprite.visible = false
#		FocusAnimation.stop()
		
		if not disabled: HoverAnimation.play_backwards("hover")
		character_within_area = false


func _on_HoverAnimation_animation_finished(anim_name):
	if anim_name == "hover":
		OutlineSprite.visible = character_within_area


func _on_HoverAnimation_animation_started(anim_name):
	if anim_name == "hover":
		OutlineSprite.visible = character_within_area
