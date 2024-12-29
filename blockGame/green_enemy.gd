extends CharacterBody2D

# this enemy will be similar to a goomba from mario

const speed = 300.0
var dirFacing = 1
const gravity = 800

func _physics_process(delta: float) -> void:
	if (!is_on_floor()):
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		
	 #TODO add raycasting so the enemy will walk to the side and turn around when it hits a platform
	
	if (is_on_floor()):
		velocity.x = -(speed * 15) * delta

	move_and_slide()
