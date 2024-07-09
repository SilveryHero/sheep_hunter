
extends CanvasLayer

@onready var timerLabel: Label = %timerLabel
@onready var scoreLabel: Label = %scoreLabel

func _process(delta: float):
	
	timerLabel.text = GameManager.timeElapsedString
	scoreLabel.text = str(GameManager.score)
	#Game Over
	if GameManager.gameOver == true: 
		queue_free()
