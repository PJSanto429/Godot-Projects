extends Node2D

@onready var character = $CharacterBody2D
@onready var animation: AnimatedSprite2D = $CharacterBody2D.get_node('animation')
var facingRight: bool

const gravity = 800
var jumpForce = -250 # TODO: when running, set jumpForce to -10
var walkSpeed = 150
var runSpeed = 225

func _ready() -> void:
	facingRight = character.scale.x > 0

func _process(delta: float) -> void:
	handleMovementInput(delta)
	handleAnimationInput()
	
func runAnimation():
	if (Input.is_action_pressed("run")):
		animation.play('run')
	else:
		animation.play('walk')
		
func freeToMove() -> bool:
	if (animation.animation in ['downAttack']):
		return animation.frame == 5
	else:
		return true

func isJumping() -> bool:
	return (animation.animation == 'jump' and animation.frame != 6)

func handleMove(direction: int): # -1, 0, or 1
	if (Input.is_action_pressed("run")):
		character.velocity.x = runSpeed * direction
	else:
		character.velocity.x = walkSpeed * direction

func handleMovementInput(delta: float):
	if (!character.is_on_floor()):
		character.velocity.y += gravity * delta
	else:
		character.velocity.y = 0
		
	if (freeToMove()):
		if (Input.is_action_just_pressed('jump') and character.is_on_floor()):
			character.velocity.y = jumpForce
			
		if (Input.is_action_pressed("right")):
			handleMove(1)
		elif (Input.is_action_pressed("left")):
			handleMove(-1)
		else:
			handleMove(0)
	
	character.move_and_slide()

func handleAnimationInput():
	if (freeToMove()):
		if (Input.is_action_just_pressed('jump')):
			animation.play('jump')
		if (!isJumping()):
			if (Input.is_action_pressed("right")):
				if (!facingRight):
					character.scale.x = -character.scale.x
					facingRight = true
				runAnimation()
			elif (Input.is_action_pressed("left")):
				if (facingRight):
					character.scale.x = -character.scale.x
					facingRight = false
				runAnimation()
			elif (Input.is_action_pressed('primaryAction')):
				animation.play('downAttack')
			elif (Input.is_action_just_pressed("secondaryAction")):
				animation.play('sideAttack')
			else:
				animation.play('idle')
