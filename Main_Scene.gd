extends Node


@export var gameOverUITemplate: PackedScene

func _ready():
	GameManager.gameEnding.connect(trigger_game_over)

func trigger_game_over():

	var gameOver_UI: GameOverUI = gameOverUITemplate.instantiate()
	gameOver_UI.timeSurvived = "01: 55"
	add_child(gameOver_UI)
