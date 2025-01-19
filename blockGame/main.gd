extends Node2D

var explosion = preload("res://explosion.tscn")
var coin = preload("res://coin.tscn")

func _ready() -> void:
	var enemies = $Enemies.get_children()
	for enemy in enemies:
		if (enemy.has_signal('wasHit')):
			enemy.connect('wasHit', Callable(self, 'onEnemyHit'))
		
func onEnemyHit(data: CharacterBody2D):
	var newExplosion: AnimatedSprite2D = explosion.instantiate()
	newExplosion.position = Vector2(data.position.x, data.position.y - 10)
	newExplosion.scale = Vector2(.15, .15)
	add_child(newExplosion)
	data.queue_free()
	
	var newCoin: AnimatedSprite2D = coin.instantiate()
	newCoin.set_meta('value', 5)
	newCoin.position = data.position
	newCoin.scale = Vector2(2, 2)
	
	$Collectables.add_child(newCoin)

func _on_player_enemy_hit_player(_enemy: Node2D):
	$Player.playerHurtAnimation()
	$UI.reduceHealth()
func _on_ui_on_zero_health():
	print('no health left')

func _on_player_on_coin_collected(value: int):
	$UI.addCoin(value)

func _on_player_on_action_hit() -> void:
	var box = $Player.get_node('collectionBox')
	if (box):
		for area in box.get_overlapping_areas():
			match area.get_parent().get_name():
				'Door':
					var keyToDelete = area.get_parent().toggleDoor($Player.keysInventory)
					print('key to delete ==> ', keyToDelete)
					if (keyToDelete):
						#$Player.keysInventory = [key for key in keys if key['id'] !=]
						pass
