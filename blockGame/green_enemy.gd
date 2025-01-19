extends CharacterBody2D

# this enemy will be similar to a goomba

signal wasHit(this: CharacterBody2D)

@onready var groundCast = $groundCast
@onready var enemyCast = $enemyCast

const speed = 3000
var dirFacing = -1
const gravity = 800
var test: int = 0

func _physics_process(delta: float) -> void:
	if (get_parent().name != 'Spawner'):
		if (!is_on_floor() and not enemyCast.is_colliding()):
			velocity.y += gravity * delta
		else:
			velocity.y = 0
			
		if (enemyCast.is_colliding()):
			var collidingWith = enemyCast.get_collider()
			if (collidingWith):
				collidingWith = collidingWith.position
				self.position.x = collidingWith.x
				$AnimatedSprite2D.stop()
		else:
			$AnimatedSprite2D.play('walk')
			
		if (is_on_floor()):
			velocity.x = dirFacing * (speed) * delta
		else:
			velocity.x = 0
		
		move_and_slide()
		
		if ((is_on_wall() or !groundCast.is_colliding()) and not enemyCast.is_colliding()):
			dirFacing = -dirFacing
			scale.x *= -1

func _on_hitbox_area_entered(_area: Area2D):
	wasHit.emit(self)
