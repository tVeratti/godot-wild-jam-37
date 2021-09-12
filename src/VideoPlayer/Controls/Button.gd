extends Node2D


signal pressed()


export(Texture) var texture:Texture setget _set_texture
var _texture:Texture

onready var ButtonSprite:Sprite = $PressArea/Sprite
onready var ActionAnimation:AnimationPlayer = $ActionAnimation
onready var PlatformBody:StaticBody2D = $Platform

var width = 0


var character_within_area:bool = false


func _ready():
	if _texture != null:
		self.texture = _texture
	
	width = ButtonSprite.texture.get_width()


func _process(delta):
	if Input.is_action_just_pressed("action") and character_within_area:
		ActionAnimation.play("action")
		emit_signal("pressed")


func _set_texture(value):
	_texture = value
	if is_instance_valid(ButtonSprite):
		ButtonSprite.texture = value
		
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


func _on_PressArea_body_entered(body):
	if body is KinematicBody2D:
		character_within_area = true


func _on_PressArea_body_exited(body):
	if body is KinematicBody2D:
		character_within_area = false
