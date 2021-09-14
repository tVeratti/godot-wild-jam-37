extends KinematicBody2D

const GRAVITY = 4000.0
const SPEED = 400.0
const SPEED_SPRINT = 800.0
const JUMP_FORCE = GRAVITY / -5

var velocity:Vector2 = Vector2.ZERO

var fixed_y:float = 0.0
var max_x:float = 0.0
var previous_on_floor:bool = false
var facing_right:bool = true

onready var JumpBoostTimer:Timer = $JumpBoostTimer
onready var JumpFallTimer:Timer = $JumpFallTimer
onready var FallThroughTimer:Timer = $FallThroughTimer
onready var MySprite:AnimatedSprite = $AnimatedSprite

var initial_collision_layer = 0

func _ready():
	State.player = self


func _physics_process(delta):
	var on_floor = is_on_floor()
	var attached = fixed_y != 0
	
	# Give the player a little extra time to register
	# a jump when they are falling off of a platform edge.
	if not on_floor and previous_on_floor:
		JumpFallTimer.start()
	
	var speed = SPEED
	if Input.is_action_pressed("sprint"):
		speed = SPEED_SPRINT
		
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		facing_right = false
		MySprite.play("walk_left")
	elif Input.is_action_pressed("right"):
		velocity.x = speed
		facing_right = true
		MySprite.play("walk_right")
	else:
		MySprite.play("idle_right" if facing_right else "idle_left")
	
	if Input.is_action_just_pressed("down"):
		if not FallThroughTimer.time_left > 0:
			FallThroughTimer.start()
			set_collision_layer_bit(initial_collision_layer, false)
			set_collision_mask_bit(initial_collision_layer, false)

	# Gravity (or nah)
	if fixed_y == 0:
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
		position.y = fixed_y
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# If the user is grabbing the timeline, don't let them exceed it
	if max_x != 0.0 and position.x > max_x:
		position.x = max_x
	
	# Simulate a bit of friction to slow the velocity down.
	if on_floor or attached: velocity.x = lerp(velocity.x, 0, 0.8)
	else: velocity.x = lerp(velocity.x, 0, 0.05)
	
	# Jumping
	if Input.is_action_just_pressed("jump") and (on_floor or JumpFallTimer.time_left > 0):
		JumpBoostTimer.start()
		velocity.y = JUMP_FORCE
	elif Input.is_action_pressed("jump") and JumpBoostTimer.time_left > 0:
		velocity.y = JUMP_FORCE
	
	previous_on_floor = on_floor


func jump():
	velocity.y = JUMP_FORCE


func _on_FallThroughTimer_timeout():
	set_collision_mask_bit(initial_collision_layer, true)
	set_collision_mask_bit(initial_collision_layer, true)
