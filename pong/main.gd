extends Node2D

var playerPaddleSpeed = 800
var ballSpeed = 400

var p2IsBot = false
var p1Velocity = Vector2.ZERO
var p2Velocity = Vector2.ZERO

var p1Score = 0
var p2Score = 0

var explosion = preload("res://sprite_animation.tscn")

@onready var ballSize = $Ball/CollisionShape2D.get_shape().get_rect().size

func _ready() -> void:
	_draw()
	$Ball.velocity = Vector2(ballSpeed, ballSpeed)
	
	var size = get_viewport().size
	resetBall()
	
	$Player1.position = Vector2(50, size.y /2)
	$Player2.position = Vector2(size.x - 50, size.y /2)

func _draw():
	var color = Color8(0, 0, 0)
	var rect = get_viewport_rect()
	draw_rect(rect, color)

func _process(delta: float) -> void:
	handleP1Movement()
	handleP2Movement()
	handleBallMovement(delta)
	fixPaddleXLocation()

func fixPaddleXLocation():
	var size = get_viewport().size
	
	if ($Player1.position.x != 50):
		$Player1.position.x = 50
	
	if ($Player2.position.x != (size.x - 50)):
		$Player2.position.x = (size.x - 50)

func getNewExplosionPosition(ballPosition: Vector2, direction: String) -> Vector2:
	var fullSize = ballSize[0]
	var halfSize = fullSize / 2

	var ballX = ballPosition.x
	var ballY = ballPosition.y
	return Vector2(ballX + halfSize, ballY + halfSize)

	#match (direction):
		#('up'):
			#return Vector2(ballX + halfSize, ballY)
		#('right'):
			#return Vector2(ballX + fullSize, ballY + halfSize)
		#('down'):
			#return Vector2(ballX + halfSize, ballY + fullSize)
		#('left'):
			#return Vector2(ballX, ballY + halfSize)
		#_:
			#return ballPosition

func handleBallMovement(delta: float):
	var collision = $Ball.move_and_collide($Ball.velocity * delta)
	
	if (collision):
		var collider = collision.get_collider()
		if (collider):
			#print(type_string(typeof(ballSize)))
			#print($Ball/CollisionShape2D.get_shape().get_rect().size)
			
			#creating an exposion at the right spot
			var newExplosion = explosion.instantiate()
			var pos = $Ball.position
			#newExplosion.position = pos
			
			if (collider.name in ["Player1", "Player2"]):
				if ($Ball.velocity.x > 0):
					newExplosion.position = getNewExplosionPosition(pos, 'right')
				else:
					newExplosion.position = getNewExplosionPosition(pos, 'left')
				
				$Ball.velocity.x = -$Ball.velocity.x
			elif (collider.name == "Walls"):
				if ($Ball.velocity.y > 0):
					newExplosion.position = getNewExplosionPosition(pos, 'down')
				else:
					newExplosion.position = getNewExplosionPosition(pos, 'up')
				
				$Ball.velocity.y = -$Ball.velocity.y
			
			add_child(newExplosion)
	
func handleP1Movement():
	p1Velocity = Vector2.ZERO
	if (Input.is_action_pressed("p1_up")):
		p1Velocity.y -= playerPaddleSpeed
	if (Input.is_action_pressed("p1_down")):
		p1Velocity.y += playerPaddleSpeed
	
	$Player1.velocity = p1Velocity
	$Player1.move_and_slide()
	
func handleP2Movement():
	if (!p2IsBot):
		p2Velocity = Vector2.ZERO
		if (Input.is_action_pressed("p2_up")):
			p2Velocity.y -= playerPaddleSpeed
		if (Input.is_action_pressed("p2_down")):
			p2Velocity.y += playerPaddleSpeed
		
		$Player2.velocity = p2Velocity
		$Player2.move_and_slide()
		
func resetBall(didScore: bool = false):
	var size = get_viewport().size
	$Ball.position = Vector2(size.x / 2, size.y / 2)
	if (didScore):
		$Ball.velocity.x = -$Ball.velocity.x
	else:
		if (randi() %2 == 0):
			$Ball.velocity.x = -$Ball.velocity.x
	if (randi() %2 == 0):
			$Ball.velocity.y = -$Ball.velocity.y

func _on_p_1_goal_body_entered(body: Node2D) -> void:
	if (body.name == "Ball"):
		resetBall(true)

func _on_p_2_goal_body_entered(body: Node2D) -> void:
	if (body.name == "Ball"):
		resetBall(true)
