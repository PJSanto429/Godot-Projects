extends CharacterBody2D

@onready var animation = $animation
var facingRight: bool

const gravity = 800
var jumpForce = -250 # TODO: when running, set jumpForce to -10
var walkSpeed = 150
var runSpeed = 225

func _ready() -> void:
	facingRight = scale.x > 0

func _process(delta: float) -> void:
	handleMovementInput(delta)
	handleAnimationInput()
	
func runAnimation():
	if (Input.is_action_pressed("run")):
		animation.play('run')
	else:
		animation.play('walk')
		
func freeToMove() -> bool:
	if (animation.animation in ['downAttack', 'sideAttack']):
		return animation.frame == 5
	else:
		return true

func isJumping() -> bool:
	return (animation.animation == 'jump' and animation.frame != 6)

func handleMove(direction: int): # -1, 0, or 1
	if (Input.is_action_pressed("run")):
		velocity.x = runSpeed * direction
	else:
		velocity.x = walkSpeed * direction

func handleMovementInput(delta: float):
	if (!is_on_floor()):
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		
	if (freeToMove()):
		if (Input.is_action_just_pressed('jump') and is_on_floor()):
			velocity.y = jumpForce
			
		if (Input.is_action_pressed("right")):
			handleMove(1)
		elif (Input.is_action_pressed("left")):
			handleMove(-1)
		else:
			handleMove(0)
	
	move_and_slide()

func handleAnimationInput():
	if (freeToMove()):
		if (Input.is_action_just_pressed('jump')):
			animation.play('jump')
		if (!isJumping()):
			if (Input.is_action_pressed("right")):
				if (!facingRight):
					scale.x = -scale.x
					facingRight = true
				runAnimation()
			elif (Input.is_action_pressed("left")):
				if (facingRight):
					scale.x = -scale.x
					facingRight = false
				runAnimation()
			elif (Input.is_action_pressed('primaryAction')):
				animation.play('downAttack')
			elif (Input.is_action_pressed("secondaryAction")):
				animation.play('sideAttack')
			else:
				animation.play('idle')
