extends Node2D

class_name Entity


signal action()
signal enter()


const MAIN_ANIMATION_NAME = "main"
const TRANSITION_TIME:float = 0.5
const TRANSITION_CURVE:float = 0.4

const SMALL_SCALE:Vector2 = Vector2(0.1, 0.1)
const FULL_SCALE:Vector2 = Vector2(1, 1)
const SPIN_DEGREES:float = 360.0 * 4

export(bool) var generate_animations:bool = true
export(float) var duration:float = 40.0
export(Texture) var sprite_texture:Texture setget set_texture
export(float) var enter_timestamp:float = 0.0
export(float) var exit_timestamp:float = 0.0
export(bool) var spin:bool = false
export(bool) var fade:bool = false
export(Vector2) var active_scale:Vector2 = FULL_SCALE
export(Vector2) var inactive_scale:Vector2 = SMALL_SCALE


onready var VideoAnimations:AnimationPlayer
var EntitySprite
var Collision:CollisionPolygon2D


var animation:Animation
var player_within:bool = false


func _ready():
	if has_node("Sprite"):
		EntitySprite = get_node("Sprite")
	elif not has_node("ColorRect"):
		EntitySprite = Sprite.new()
		EntitySprite.name = "Sprite"
		add_child(EntitySprite)
	
#	if EntitySprite.has("material"):
#		var mat = Material.new()
#		EntitySprite.mat
	
	if has_node("AnimationPlayer"):
		VideoAnimations = get_node("AnimationPlayer")
	
	if sprite_texture != null:
		set_texture(sprite_texture)
	
	if has_node("StaticBody2D/CollisionPolygon2D"):
		Collision = get_node("StaticBody2D/CollisionPolygon2D")
	
	if generate_animations:
		_create_animation()
	
	if is_instance_valid(VideoAnimations) and VideoAnimations.has_animation(MAIN_ANIMATION_NAME):
		VideoAnimations.play(MAIN_ANIMATION_NAME)


func _process(delta):
	if is_instance_valid(VideoAnimations):
		if VideoAnimations.is_playing():
			VideoAnimations.seek(State.timeline.timestamp, true)
		
	if Input.is_action_just_pressed("action") and player_within:
		emit_signal("action")


func _create_animation():
	animation = Animation.new()
	animation.length = duration
	
	if not is_instance_valid(VideoAnimations):
		VideoAnimations = AnimationPlayer.new()
		add_child(VideoAnimations)
	
	VideoAnimations.add_animation(MAIN_ANIMATION_NAME, animation)
	
	var track_index = 0
	
	_create_track(track_index, ".:visible", true, false, 0.4)
	if fade: _create_track(track_index, "Sprite:modulate", Color.white, Color(0,0,0,0))
	
	# Collision
	var collision_node
	if  has_node("StaticBody2D/CollisionShape2D"): collision_node = "StaticBody2D/CollisionShape2D"
	elif has_node("StaticBody2D/CollisionPolygon2D"): collision_node = "StaticBody2D/CollisionPolygon2D"
	
	if collision_node != null:
		_create_track(track_index, "%s:disabled" % collision_node, false, true)
#		_create_track(track_index, "StaticBody2D/CollisionShape2D:scale", FULL_SCALE, SMALL_SCALE)
	
	# Sprite
	var is_sprite = is_instance_valid(EntitySprite) and EntitySprite is Sprite
	var scale_property = "scale" if is_sprite else "rect_scale"
	var rotation_property = "rotation_degrees" if is_sprite else "rect_rotation"
	
	_create_track(track_index, "Sprite:%s" % scale_property, active_scale, inactive_scale)

	# Spin
	if spin and collision_node != null:
		get_node(collision_node).one_way_collision = false
		_create_track(track_index, "Sprite:%s" % rotation_property, 0, SPIN_DEGREES, 1, false)
		_create_track(track_index, "%s:rotation_degrees" % collision_node, 0, SPIN_DEGREES, 1, false)


func _create_track(
	index:int,
	path:String,
	on_value,
	off_value,
	offset = 0.0,
	initial:bool = true,
	transition_time:float = TRANSITION_TIME):
	
	animation.add_track(0, index)
	animation.length = duration
	
	animation.track_set_path(index, path)
	
	if initial: animation.track_insert_key(index, 0.0, off_value) # off
	
	# off ----
	
	if offset == 0:
		animation.track_insert_key(index, enter_timestamp - transition_time, off_value, TRANSITION_CURVE) # off
		animation.track_insert_key(index, enter_timestamp, on_value, TRANSITION_CURVE) # on
	else:
		animation.track_insert_key(index, enter_timestamp - offset, on_value, TRANSITION_CURVE) # on
		
	# on ----
	
	if offset == 0:
		animation.track_insert_key(index, exit_timestamp, on_value, TRANSITION_CURVE) # on
		animation.track_insert_key(index, exit_timestamp + transition_time, off_value, TRANSITION_CURVE) # off
	else:
		animation.track_insert_key(index, exit_timestamp + offset, off_value, TRANSITION_CURVE) # off
	
	index += 1


func destroy():
	queue_free()


func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		player_within = true
		emit_signal("enter")


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		player_within = false


func set_texture(value):
	sprite_texture = value
	if is_instance_valid(EntitySprite):
		EntitySprite.texture = value
