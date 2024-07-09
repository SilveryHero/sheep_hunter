extends Node

signal gameEnding

var player: Player
var player_position: Vector2 
var score: int = 0
var gameOver: bool = false
var monstersDefeated: int = 0
var timeElapsed: float = 0.0
var timeElapsedString: String

func _process(delta: float): 
	timeElapsed += delta
	var timeElapsedSec: int = floori(GameManager.timeElapsed)
	var seconds: int = timeElapsedSec % 60 
	var minutes: int = timeElapsedSec / 60
	timeElapsedString = "%02d:%02d" % [minutes, seconds]

func end_game():
	if gameOver: return

	gameOver = true
	gameEnding.emit()
	
	
func reset():
	player = null
	player_position = Vector2.ZERO
	gameOver = false
	score= 0
	monstersDefeated = 0
	
	timeElapsed = 0.0
	timeElapsedString = "00:00"
	for connection in gameEnding.get_connections():
		gameEnding.disconnect(connection.callable)
