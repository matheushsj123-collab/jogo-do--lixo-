extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Pega a gravidade padrão das configurações do projeto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D
@onready var som_pulo = $AudioStreamPlayer

func _physics_process(delta):
	# 1. Aplica a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		som_pulo.play()

	# 3. Movimento horizontal
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. Animação
	if not is_on_floor():
		sprite.play("jump")
	elif direction != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")

	# 5. Movimento e colisão
	move_and_slide()


func take_damage():
	Global.health -= 1

	if Global.health <= 0:
		die()


func die():
	print("Game Over - O jogador morreu!")

	Global.health = 3
	Global.coins = 0

	get_tree().reload_current_scene()
