extends CharacterBody2D

const SPEED = 150.0

@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta):
	# Captura a direção do movimento (setas do teclado ou WASD)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		sprite.play("walk")
		
		# Espelha o personagem horizontalmente ao andar para a esquerda
		if direction.x != 0:
			sprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		sprite.play("Idle")

	move_and_slide()
