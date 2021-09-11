extends KinematicBody2D

const GRAVITY = 1000.0
const SPEED = 400.0

var velocity:Vector2 = Vector2.ZERO

var fixed_y:float = 0.0


func _ready():
	State.player = self


func _physics_process(delta):
	var on_floor = is_on_floor()
	var attached = fixed_y != 0
	
	var slow_down = false
	if Input.is_action_pressed("left"):
		if on_floor or attached: velocity.x = -SPEED
		elif velocity.x > 0: slow_down = true
	elif Input.is_action_pressed("right"):
		if on_floor or attached: velocity.x = SPEED
		elif velocity.x < 0: slow_down = true
	
	if slow_down: lerp(velocity.x, 0, 0.5)
	
	if fixed_y == 0:
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
		position.y = fixed_y
	
	velocity = move_and_slide(velocity, Vector2.UP)
	position.x = clamp(position.x, 20, 1280 - 20)
	
	if on_floor or attached:
		velocity.x = lerp(velocity.x, 0, 0.3)
	
	if Input.is_action_just_pressed("jump") and on_floor:
		velocity.y = -400
