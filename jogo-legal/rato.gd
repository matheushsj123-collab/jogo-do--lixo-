class_name rato
extends CharacterBody2D

const SPEED = 120.0
const DAMAGE = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var player: Node2D = null
var player_in_hitbox: Node2D = null
var is_attacking: bool = false
var is_dead: bool = false

func _ready() -> void:
	visible = true
	if animated_sprite:
		animated_sprite.visible = true
		animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Aplica a gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 1. Se estiver na área de dano, inicia o ciclo de mordidas
	if player_in_hitbox != null:
		if not is_attacking:
			start_bite()
	
	# 2. Se não estiver atacando e estiver vendo o jogador, persigue
	elif player != null and not is_attacking:
		var offset_x = player.global_position.x - global_position.x
		
		# Zona morta de 8 pixels para não girar se você estiver em cima
		if abs(offset_x) > 8.0:
			var direction = sign(offset_x)
			velocity.x = direction * SPEED
			animated_sprite.flip_h = direction > 0
			animated_sprite.play("walk")
		else:
			velocity.x = 0
			animated_sprite.play("idle")
	
	# 3. Se perdeu de vista e não está atacando, para
	elif not is_attacking:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("idle")

	move_and_slide()

# --- LÓGICA DE MORDIDAS REPETIDAS ---

func start_bite() -> void:
	is_attacking = true
	velocity.x = 0
	
	# Loop contínuo enquanto o jogador estiver na Hitbox
	while player_in_hitbox != null and not is_dead:
		animated_sprite.play("bite")
		
		# Aplica o dano no jogador a cada mordida
		if player_in_hitbox.has_method("take_damage"):
			player_in_hitbox.take_damage(DAMAGE)
		
		# Espera o fim da animação da mordida atual para dar a próxima
		await animated_sprite.animation_finished

	# Quando o jogador sai da Hitbox, cancela o estado de ataque
	is_attacking = false

# --- SINAIS DE VISÃO (DETECTION AREA) ---

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null

# --- SINAIS DE ATAQUE (HITBOX) ---

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = body

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body == player_in_hitbox:
		player_in_hitbox = null

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	animated_sprite.play("death")
