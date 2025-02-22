extends Node2D

@export var game_state = 0
@onready var demon_spawner = get_node("DemonSpawner")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_state == 0:
		# Estado Inicial
		demon_spawner.spawn_rate = 4.0
	elif game_state == 1:
		# Após 5 itens serem entregues corretamente
		demon_spawner.spawn_rate = 2.0
	elif game_state == 2:
		# Após 15 itens serem entregues corretamente
		demon_spawner.spawn_rate = 1.0
	elif game_state == 3:
		# Após 19 itens serem entregues corretamente
		# Só falta 1 item para vencer
		demon_spawner.spawn_rate = 0.6
	elif game_state == 4:
		# Fim do jogo, vitória
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	elif game_state == 5:
		# Fim do jogo, derrota
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
