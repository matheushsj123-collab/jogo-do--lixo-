extends CharacterBody2D

const SPEED = 150.0
# Pega a gravidade padrão das configurações do seu projeto na Godot
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	# 1. Aplica a gravidade se o personagem estiver no ar
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Captura apenas o movimento horizontal (Esquerda / Direita)
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		sprite.play("walk")
		sprite.flip_h = direction < 0
	else:
		# Zera apenas a velocidade X para parar de andar, mantendo a queda no Y
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			sprite.play("idle")

	# 3. Executa a física de movimento e colisão
	move_and_slide()
