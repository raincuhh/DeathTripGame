extends Node2D

@onready var camera = $mainCamera
@onready var player = $player
@onready var ground = $Ground
@onready var playerUi = $playerGameUi
@onready var loseScreen = $loseScreen

#physical obstacles
var advertisingBoard1 = preload("res://game/obstacles/advertisingBoard1.tscn")
var advertisingBoard2 = preload("res://game/obstacles/advertisingBoard2.tscn")
var advertisingBoard3 = preload("res://game/obstacles/advertisingBoard3.tscn")
var lampPost1 = preload("res://game/obstacles/lampPost1.tscn")
var lampPost2 = preload("res://game/obstacles/lampPost2.tscn")
var lampPost3 = preload("res://game/obstacles/lampPost3.tscn")
var trafficCone = preload("res://game/obstacles/trafficCone.tscn")
#indirect obstacles
var beer1 = preload("res://game/obstacles/beer1.tscn")
var beer2 = preload("res://game/obstacles/beer2.tscn")
var beer3 = preload("res://game/obstacles/beer3.tscn")
var water1 = preload("res://game/waterBottle1.tscn")

var drinkTypes := [
	beer1,
	beer2,
	beer3,
	water1,
]
var drinks : Array

var obstacleTypes := [
	advertisingBoard1,
	advertisingBoard2,
	advertisingBoard3,
	lampPost1,
	lampPost2, 
	lampPost3,
	trafficCone,
]
var obstacles : Array

var lastObs
var lastDrk

const PLAYERSTARTPOS = Vector2(75, 327.5)
const CAMERASTARTPOS = Vector2(320, 180)
var DIFF
const MAXDIFF : int = 2
var gameRunning = false
var speed : float
const STARTSPEED : float = 3.5
const MAXSPEED : int = 8
const SPEEDAMPLIFIER = 8000

var score : float = 5
var highScore : float
var drunknessLevel : int = 0
const DRUNKNESSLEVELMAX : int = 6
const DRUNKNESSLEVELMIN : int = 0

var count : float
var countIncrementInterval = 0.3
var countTimeCounter = 0.0

var screenSize : Vector2i
var groundHeight : int
var gamePaused = false

func _ready():
	gameRunning = true
	screenSize = Vector2i(640, 360)#get_window().size
	groundHeight = ground.get_node("Sprite2D").texture.get_height()
	#print(groundHeight)
	#print(screenSize.y)
	newGame()
	
	signalBus.connect("restartGame", newGame)

func newGame():
	gameRunning = true
	print("newGame")
	loseScreen.hide()
	player.position = PLAYERSTARTPOS
	player.velocity = Vector2i(0,0)
	camera.position = CAMERASTARTPOS
	ground.position = Vector2i(0,0)
	speed = 0.0
	score = 0
	count = 0
	playerUi.updateScoreLabel(count)
	drunknessLevel = 0
	playerUi.updateDrunknessLevel(drunknessLevel)
	
	for obs in obstacles:
		if is_instance_valid(obs):
			obs.queue_free()
	obstacles.clear()
	for drk in drinks:
		if is_instance_valid(drk):
			drk.queue_free()
	drinks.clear()

func _process(delta):
	if gameRunning:
		countTimeCounter += delta
		if countTimeCounter > countIncrementInterval:
			count += 10
			updateScore()
			countTimeCounter = 0.0
		
		speed = STARTSPEED + score / SPEEDAMPLIFIER
		if speed > MAXSPEED:
			speed = MAXSPEED
		changeDifficulty()
		
		global.maxSpeed = MAXSPEED
		global.speed = speed
		
		obstacleSpawner()
		drinksSpawner()
		
		camera.position.x += speed
		player.position.x += speed
		
		score += speed
		
		#print(score)
		updateGround()
		
		for obs in obstacles:
			if obs.position.x < (camera.position.x - screenSize.x):
				removeObs(obs)
		
		var index = 0
		while index < drinks.size():
			var drk = drinks[index]
			if is_instance_valid(drk) && drk.position.x < (camera.position.x - screenSize.x):
				removeDrk(drk)
			else:
				index += 1

func updateGround():
	if camera.position.x - ground.position.x > screenSize.x * 1.5:
			ground.position.x += screenSize.x


var lastObstacleType = null

func obstacleSpawner():
	if obstacles.is_empty() or lastObs.position.x < score + randi_range(150, 400):
		
		var availableObstacleTypes = obstacleTypes.duplicate()
		if lastObstacleType in availableObstacleTypes:
			availableObstacleTypes.erase(lastObstacleType)
		var obsCurrentType = availableObstacleTypes[randi() % availableObstacleTypes.size()]
		lastObstacleType = obsCurrentType
		#print(obsCurrentType)
		
		var obs
		obs = obsCurrentType.instantiate()
		
		var obstacleYPositions = {
			advertisingBoard1: 107,
			advertisingBoard2: 140, #127
			advertisingBoard3: 148,
			lampPost1: 70,
			lampPost2: 65,
			lampPost3: 70,
			trafficCone: 32,
		}
		
		var spawnOffsetRangeX = randi_range(10, 60)
		var spawnOffsetRangeY = randi_range(280, 380)
		var spawnOffsetX = randi_range(spawnOffsetRangeX, spawnOffsetRangeY)
		print(spawnOffsetX)
		
		var obsX : int = screenSize.x + score + spawnOffsetX
		var obsY : int = screenSize.y - obstacleYPositions.get(obsCurrentType, 0)
		lastObs = obs
		
		addObs(obs, obsX, obsY)

func addObs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hitObs)
	add_child(obs)
	obstacles.append(obs)

func removeObs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hitObs(body):
	if body.name == "player":
		#print("collided")
		lose()

func changeDifficulty():
	DIFF = score / SPEEDAMPLIFIER
	if DIFF > MAXDIFF:
		DIFF = MAXDIFF
	#print(DIFF)

var lastDrinkType = null

func drinksSpawner():
	if drinks.is_empty() or (lastDrk != null and lastDrk.position.x < (score + randi_range(300, 500))): #drinks.is_empty() or lastDrk.position.x < score + randi_range(300, 500):
		var availableDrinkTypes = drinkTypes.duplicate()
		if lastDrinkType in availableDrinkTypes:
			availableDrinkTypes.erase(lastDrinkType)
		
		var drinksCurrentType = availableDrinkTypes[randi() % availableDrinkTypes.size()]
		lastDrinkType = drinksCurrentType
		
		#if drinksCurrentType == beer1:
		#	print("beer1")
		
		var drk
		drk = drinksCurrentType.instantiate()
		
		var drinkSpawnFirstValue = 20
		var drinkSpawnSecondValue = 340
		
		var drinksYPosition = {
			beer1: randi_range(20, 340),
			beer2: randi_range(20, 340),
			beer3: randi_range(20, 340),
			water1: randi_range(20, 340),
		}
		
		var spawnOffsetRangeX = randi_range(10, 60)
		var spawnOffsetRangeY = randi_range(220, 300)
		var spawnOffsetX = randi_range(spawnOffsetRangeX, spawnOffsetRangeY)
		
		var drkX : int = screenSize.x + score + spawnOffsetX
		var drkY : int = screenSize.y - drinksYPosition.get(drinksCurrentType, 0)
		lastDrk = drk
		
		addDrinks(drk, drkX, drkY, drinksCurrentType)

func addDrinks(drk, x, y, drinkType):
	drk.position = Vector2i(x, y)
	drk.body_entered.connect(hitDrink.bind([drinkType]))
	add_child(drk)
	drinks.append(drk)

func hitDrink(body, drinkTypes):
	if body.name == "player":
		#print("collided")
		if drinkTypes.has(beer1) || drinkTypes.has(beer2) || drinkTypes.has(beer3):
			increaseDrunkness()
		else:
			decreaseDrunkness()

func removeDrk(drk):
	#print("Removing drink:", drk)
	if drinks.has(drk):
		drk.queue_free()
		drinks.erase(drk)
		#print("removedDrink:", drk)
	else:
		print("Drink not found in drinks array:", drk)

func increaseDrunkness():
	#print("drunkness+")
	drunknessLevel += 1
	limitDrunknessLevel(drunknessLevel)
	playerUi.updateDrunknessLevel(drunknessLevel)
	print(drunknessLevel)

func decreaseDrunkness():
	#print("drunkness-")
	drunknessLevel -= 1
	limitDrunknessLevel(drunknessLevel)
	playerUi.updateDrunknessLevel(drunknessLevel)
	#print(drunknessLevel)

func limitDrunknessLevel(e):
	if e > DRUNKNESSLEVELMAX:
		drunknessLevel = DRUNKNESSLEVELMAX
	if e < DRUNKNESSLEVELMIN:
		drunknessLevel = DRUNKNESSLEVELMIN

func lose():
	loseScreen.show()
	loseScreen.updateGlobalScoreLabel()
	gameRunning = false

func updateScore():
	if not playerUi:
		print("playerui incorrectly referenced")
		return
	playerUi.updateScoreLabel(count)

#func checkHighScore():
#	if not highScore:
#		print("highscore incorrectly referenced")
#		return
#	if count > highScore:
#		highScore = count
#		loseScreen.get_node("highScore").text = str(highScore)
