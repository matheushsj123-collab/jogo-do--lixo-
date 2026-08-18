extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Pega a gravidade padrão das configurações do seu projeto na Godot
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	# 1. Aplica a gravidade se o personagem estiver no ar
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Pulo (só pode pular se estiver no chão)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Captura apenas o movimento horizontal (Esquerda / Direita)
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		# Zera apenas a velocidade X para parar de andar, mantendo a queda no Y
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. Escolhe a animação certa (prioridade: pulo > andar > parado)
	if not is_on_floor():
		sprite.play("jump")
	elif direction != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")

	# 5. Executa a física de movimento e colisão
	move_and_slide()

# Adicione no final do script do Player.gd
func take_damage():
	Global.health -= 1 # Tira 1 do Global.health

	if Global.health <= 0: # Se a vida chegar a zero ou menos...
		die()              # ...chama a função de morte

func die():
	print("Game Over - O jogador morreu!")
	Global.health = 3 # Reseta vida para a próxima tentativa
	Global.coins = 0  # Opcional: faz o jogador perder as moedas ao morrer

	# Recarrega a cena atual imediatamente (recomeça a fase)
	# Mais tarde vamos mudar isso para ir para uma Tela de Game Over de verdade
	get_tree().reload_current_scene()
