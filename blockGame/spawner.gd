extends Node2D

signal createMob(
	position: Vector2,
	mob
)

@onready var allFrames = [
	$Enabled/frame1,
	$Enabled/frame2,
	$Enabled/frame3,
	$Enabled/frame4
]
var rotationSpeed = 2

var childToSpawn

func _process(delta: float) -> void:
	
	if (len(get_children()) > 2):
		$Disabled.visible = false
		$Enabled.visible = true
		for index in range(len(allFrames)):
			var frame = allFrames[index]
			if (index % 2 == 0):
				frame.rotation = frame.rotation + (rotationSpeed * delta)
			else:
				frame.rotation = frame.rotation - (rotationSpeed * delta)
	else:
		$Disabled.visible = true
		$Enabled.visible = false

func _on_timer_timeout() -> void:
	pass # Replace with function body.
