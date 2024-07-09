class_name GameOverUI

extends CanvasLayer

@onready var timeLabel: Label = %endTimeLabel
@onready var monstersLabel: Label = %endMonstersLabel
@onready var scoreLabel: Label = %endScoreLabel

@export var restartDelay: float = 5.0
var restartCooldown: float
var timeSurvived: String



func _ready():
	
	timeLabel.text = GameManager.timeElapsedString
	monstersLabel.text = str(GameManager.monstersDefeated)
	scoreLabel.text = str(GameManager.score)
	restartCooldown = restartDelay
	

func _process(delta: float) -> void:
	restartCooldown -= delta
	if restartCooldown <= 0.0:
		restart_game()
		
		
func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()

	
	
