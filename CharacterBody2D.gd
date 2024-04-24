extends CharacterBody2D


const SPEED = 300.0
const SPRINT_MULTIPLIER = 2.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		$AnimatedSprite2D.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_pressed("player_speedmove"):
		velocity.x = direction * SPEED * SPRINT_MULTIPLIER
		$AnimatedSprite2D.set_speed_scale(2)
		
	if direction>0:
		$AnimatedSprite2D.flip_h = false
	elif direction<0:
		$AnimatedSprite2D.flip_h = true
		
	if (velocity.x != 0) and not Input.is_action_pressed("player_speedmove") and is_on_floor():
		$AnimatedSprite2D.play("Walk")
		$AnimatedSprite2D.set_speed_scale(1)
	elif (velocity.x != 0) and Input.is_action_pressed("player_speedmove") and is_on_floor():
		$AnimatedSprite2D.play("Walk")
		$AnimatedSprite2D.set_speed_scale(2)
	elif (velocity.x == 0) and is_on_floor():
		$AnimatedSprite2D.play("Idle")

	move_and_slide()
