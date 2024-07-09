extends Node

@export var mobSpawner: MobSpawner
@export var initialRate: float = 60.0
@export var mobsIncrease: float = 2
@export var waveDuration: float = 20.0
@export var breakIntensity: float = 0.5

var time: float = 0.0

func _process(delta: float) -> void:
	time += delta
	
	var spawnRate = initialRate + (mobsIncrease * GameManager.score)
	
	var sinWave = sin((time*TAU)/waveDuration)
	var waveFactor = remap(sinWave, -1.0, 1.0, breakIntensity, 1.0)
	spawnRate *= waveFactor
	
	mobSpawner.mobsPerMinute = spawnRate
