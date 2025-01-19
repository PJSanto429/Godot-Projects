extends CanvasLayer

signal onZeroHealth

var health: int = 6
var coins: int = 0

@onready var heart1 = $Control/HBoxContainer/heart1
@onready var heart2 = $Control/HBoxContainer/heart2
@onready var heart3 = $Control/HBoxContainer/heart3

var fullHeart = load('res://assets/hearts/full.png')
var halfHeart = load('res://assets/hearts/half.png')
var emptyHeart = load("res://assets/hearts/empty.png")

func reduceHealth():
	health -= 1
	match health:
		5:
			heart3.texture = halfHeart
		4:
			heart3.texture = emptyHeart
		3:
			heart2.texture = halfHeart
		2:
			heart2.texture = emptyHeart
		1:
			heart1.texture = halfHeart
		0:
			heart1.texture = emptyHeart
			onZeroHealth.emit()

@onready var digitOne: TextureRect = $Control/onesNum
@onready var digitTwo: TextureRect = $Control/tensNum
@onready var digitThree: TextureRect = $Control/hundredsNum
@onready var digitFour: TextureRect = $Control/thousandsNum

var allNums = [
	preload('res://assets/numbers/0.png'),
	preload('res://assets/numbers/1.png'),
	preload('res://assets/numbers/2.png'),
	preload('res://assets/numbers/3.png'),
	preload('res://assets/numbers/4.png'),
	preload('res://assets/numbers/5.png'),
	preload('res://assets/numbers/6.png'),
	preload('res://assets/numbers/7.png'),
	preload('res://assets/numbers/8.png'),
	preload('res://assets/numbers/9.png')
]

func addCoin(value: int):
	coins += value
	var splitNum = str(coins)
	while (len(splitNum) < 4):
		splitNum = '0' + splitNum
	splitNum = splitNum.split('')
	
	setNewValue(digitFour, int(splitNum[0]))
	setNewValue(digitThree, int(splitNum[1]))
	setNewValue(digitTwo, int(splitNum[2]))
	setNewValue(digitOne, int(splitNum[3]))

func setNewValue(digit: TextureRect, number: int):
	digit.texture = allNums[number]
