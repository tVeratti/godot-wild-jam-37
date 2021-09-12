extends Entity

const TRANSITION_TIME:float = 0.5
const TRANSITION_CURVE:float = 0.4

const SMALL_SCALE:Vector2 = Vector2(0.1, 0.1)
const FULL_SCALE:Vector2 = Vector2(8, 0.1)
const SPIN_DEGREES:float = 360.0 * 8

export(float) var duration:float = 40.0
export(float) var enter_timestamp:float = 0.0
export(float) var exit_timestamp:float = 0.0
export(bool) var spin:bool = false

var animation:Animation


func _ready():
	_create_animation()
	._ready()


func _create_animation():
	animation = Animation.new()
	VideoAnimations.add_animation(MAIN_ANIMATION_NAME, animation)
	
#	animation.add_track(0)
	animation.length = duration
	
	# Collision
	_create_track(0, "StaticBody2D/CollisionShape2D:disabled", false, true, TRANSITION_TIME / 2)
#	_create_track(0, "StaticBody2D/CollisionShape2D:scale", FULL_SCALE, SMALL_SCALE)
	
	# Sprite
	_create_track(1, "Sprite:scale", FULL_SCALE, SMALL_SCALE)
	_create_track(2, "Sprite:visible", true, false, 0.5)
	
	# Spin
	if spin:
		$StaticBody2D/CollisionShape2D.one_way_collision = false
		_create_track(3, "Sprite:rotation_degrees", 0, SPIN_DEGREES, 1, false)
		_create_track(4, "StaticBody2D/CollisionShape2D:rotation_degrees", 0, SPIN_DEGREES, 1, false)


func _create_track(
	index:int,
	path:String,
	on_value,
	off_value,
	offset = 0.0,
	initial:bool = true):
	
	animation.add_track(0, index)
	animation.length = duration
	
	animation.track_set_path(index, path)
	
	if initial: animation.track_insert_key(index, 0.0, off_value) # off
	
	# off ----
	
	if offset == 0:
		animation.track_insert_key(index, enter_timestamp - TRANSITION_TIME, off_value, TRANSITION_CURVE) # off
		animation.track_insert_key(index, enter_timestamp, on_value, TRANSITION_CURVE) # on
	else:
		animation.track_insert_key(index, enter_timestamp - offset, on_value, TRANSITION_CURVE) # on
		
	# on ----
	
	if offset == 0:
		animation.track_insert_key(index, exit_timestamp, on_value, TRANSITION_CURVE) # on
		animation.track_insert_key(index, exit_timestamp + TRANSITION_TIME, off_value, TRANSITION_CURVE) # off
	else:
		animation.track_insert_key(index, exit_timestamp + offset, off_value, TRANSITION_CURVE) # off
