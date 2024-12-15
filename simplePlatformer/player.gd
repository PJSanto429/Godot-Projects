extends CharacterBody2D

const speed = 450.0

var currentSpeed = speed
var runSpeed = 1000
var dashSpeed = 2000
const jumpSpeed = -500.0

var canDoubleJump = false
var canDash = false
var facingDirection = 1
var lastYHeight

#timers
@onready var dashTimer: Timer = $"Timers/dashTimer"

func _physics_process(delta: float) -> void:
	if is_on_wall():
		dashTimer.stop()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# resetting things that can be done in the air back to true
		canDash = true
		canDoubleJump = true
		
	if (Input.is_action_just_pressed('dash') and canDash):
		canDash = false
		dashTimer.start()

	# Handle jump.
	if (Input.is_action_just_pressed("jump") and canDoubleJump): # and is_on_floor():
		if (!is_on_floor()):
			canDoubleJump = false
		velocity.y = jumpSpeed
		
	# Handle sprint
	if (Input.is_action_pressed("sprint")):
		pass

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if (direction && dashTimer.time_left == 0):
		changePlayerDirection(direction)
		facingDirection  = direction
		velocity.x = direction * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)

	if (dashTimer.time_left > 0):
		velocity.x = dashSpeed * facingDirection
		position.y = lastYHeight
	else:
		lastYHeight = position.y

	move_and_slide()

func changePlayerDirection(direction: int):
	if (facingDirection != direction):
		dashTimer.stop()
		$directionArrow.rotate(deg_to_rad(180))
