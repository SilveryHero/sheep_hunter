class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 3
@export_category("Sword")
@export var sword_damage: int = 2
@export_category("Ritual")
@export var ritual_damage: int = 1
@export var ritual_interval:float = 30
@export var ritual_scene: PackedScene
@export_category("Life")
@export var health: int = 100
@export var max_health: int = 100
@export var death_prefab: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea

var input_vector: Vector2 = Vector2(0, 0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 0.0


func _ready():
	GameManager.player = self

func _process(delta: float) -> void:
	#Game Over
	if GameManager.gameOver == true: 
		return
	GameManager.player_position = position
	_read_input() #inputs de movimento
	run_indle_animation() #animações parado e correndo
	#sistema de ataque
	if Input.is_action_just_pressed("attack"):
		attack()
	attack_cooldown_set(delta)
	
	sprite_spin() #girar sprite	
	update_hitbox_detection(delta) #processar dano	
	update_ritual(delta) #ritual

func taking_damage (amount: int) -> void:
	if health <= 0: return
	
	health -= amount
	print("Player recebeu dano de ", amount, ". A vida total é de ", health, "/", max_health)
	
	#Piscar node
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	#Processar morte
	if health <= 0:
		die()
		
func update_hitbox_detection(delta: float) -> void:
	#Temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	#Frequencia
	hitbox_cooldown = 0.5
	
	#Detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 2
			taking_damage(damage_amount)
			
func die() -> void:
	GameManager.end_game()
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
	print("Player morreu!")
	GameManager.gameOver = true
	queue_free()
func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	print("Player recebeu cura de ", amount, ". A vida total é de ", health, "/", max_health)
	return health
func update_ritual(delta: float) -> void: 
	#Atualizar temporizador
	ritual_cooldown -=delta
	if ritual_cooldown > 0: return
	ritual_cooldown = ritual_interval
	
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)
	
func sprite_spin() -> void:
	#girar sprite
	if not is_attacking:
		if input_vector.x >0:
			sprite.flip_h = false
		elif input_vector.x <0:
			sprite.flip_h = true

func run_indle_animation() ->void:
	#tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("Idle")
		
func attack_cooldown_set(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("Idle")
	
func _read_input() -> void:
		#Obter input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#Apagar deadzone
	var deadzone = 0.15
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0.0
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0.0
	
	#atualizar is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
		
func _physics_process(delta: float) -> void:

	#Modificar velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.1)
	move_and_slide()
	
func attack() -> void:
	if is_attacking:
		return
		#girar sprite
	if input_vector.x >0:
		sprite.flip_h = false
	elif input_vector.x <0:
		sprite.flip_h = true
	animation_player.play("attack_side_1")
	attack_cooldown = 0.7
	is_attacking = true
	
func dealing_damage() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				enemy.damage(sword_damage)
	var enemies = get_tree().get_nodes_in_group("enemies")

