extends Area2D

@export_file("*.tscn") var next_scene_path
@export var tempo_antes_da_fase := 2.0

@onready var musica = $AudioStreamPlayer

var ativado := false

func _on_body_entered(body):
	if body.name == "Player" and not ativado:
		ativado = true
		
		# Toca a música
		musica.play()
		
		# Espera a música tocar por 2 segundos
		await get_tree().create_timer(tempo_antes_da_fase).timeout
		
		change_level()

func change_level():
	if next_scene_path:
		get_tree().change_scene_to_file("res://fase_2.tscn")
