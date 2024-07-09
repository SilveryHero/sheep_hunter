class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
@export var mobsPerMinute: float = 60.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D
var cooldown: float = 0.0




func _process(delta: float):
	#Game Over
	if GameManager.gameOver == true: 
		return 
	
	# Temporizador
	cooldown -= delta
	if cooldown > 0: return
	
	# Frequência
	var interval = 60.0 / mobsPerMinute
	cooldown = interval

	#validação do ponto
	var point = get_point()
	var worldState = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D
	var result: Array = worldState.intersect_point(parameters, 1)
	if not result.is_empty(): return
	# Instanciar uma criatura aleatória
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = get_point()
	get_parent().add_child(creature)


func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
