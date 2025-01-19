extends CharacterBody2D

@onready var collision: CollisionShape2D = $doorCollide
@onready var animation: AnimatedSprite2D = $animation

func _ready() -> void:
	changeDoor()
		
func changeDoor(playAnimation = true):
	var isOpen = get_meta("open")

	collision.disabled = isOpen
	
	if (isOpen):
		animation.play('open')
	else:
		animation.play('close')

func toggleDoor(keys: Array) -> int:
	if (get_meta('open')):
		set_meta("open", false)
		changeDoor()
		return -1
	else:
		return unlockDoor(keys)

func unlockDoor(keys: Array) -> int:
	var key

	if (get_meta("locked")):
		var neededKeyId = get_meta("keyId")
		for oneKey in keys:
			if (oneKey['id'] == neededKeyId):
				key = oneKey
				set_meta("locked", false)
	
	if (!get_meta("locked")):
		set_meta("open", not get_meta('open'))
		changeDoor()
		
	if (key):
		if (key['oneTimeUse']):
			return key['id']
		return -1
	return -1
