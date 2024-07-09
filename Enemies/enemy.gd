class_name Enemy
extends Node2D
@export_category("Life")
@export var health: int = 10
@export var death_prefab: PackedScene
var damageDigitPrefab: PackedScene

@onready var damageDigitMarker = $damageMarker

@export_category("Drops")
@export var dropChance: float = 0.1
@export var dropItens: Array[PackedScene]
@export var itemChances: Array[float]




func _ready():
	damageDigitPrefab = preload("res://gameUI/damageDigit.tscn")

func damage(amount: int) -> void:
	health -= amount
	print("Inimigo recebeu dano de ", amount, ". A vida total é de ", health)
	
	#Piscar node
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	#Damage Digit
	var damageDigit = damageDigitPrefab.instantiate()
	damageDigit.value = amount
	if damageDigitMarker:
		damageDigit.global_position =  damageDigitMarker.global_position
		
	get_parent().add_child(damageDigit)
	#Morte
	if health <=0:
		die()
		
func die() -> void:
	#animação de morte
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	#pontuação	
	GameManager.score += 1
	GameManager.monstersDefeated += 1
	#drop
	if randf() <= dropChance:
		drop_item()
		
	queue_free()
	
	
func drop_item() -> void:
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)
	
func get_random_drop_item() -> PackedScene:
	if dropItens.size() == 1:
		return dropItens[0]
	
	var maxChance: float = 0.0
	for dropChance in itemChances:
		maxChance += dropChance
	
	var randomValue =  randf() * maxChance
	
	var roleta: float = 0.0
	for i in dropItens.size():
		var dropItem = dropItens[i]
		var dropChance = itemChances[i] if i < itemChances.size() else 1 
		if randomValue <= dropChance + roleta:
			return dropItem
		roleta += dropChance
		
	return dropItens[0]
	pass
	
	
