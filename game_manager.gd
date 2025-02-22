extends Node2D

@export var game_state = 0
@onready var timer: Timer = $Timer
@onready var demon_spawner = get_node("DemonSpawner")
@onready var ritual = get_parent().get_node("Ritual")
@onready var player = get_parent().get_node("Player")

var velocidade_aumento_spawn_rate = 0.1

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
		# Fim do jogo, derrota (MORTE DO MAGO)
		if not timer.is_stopped():
			return
		_darkening_ritual()
		timer.start()
	elif game_state == 6:
		# Fim do jogo, derrota (MORTE DO PLAYER)
		await get_tree().create_timer(10).timeout
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	elif game_state == 7:
		# Fim do jogo, derrota (ITEM INCORRETO)
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_timer_timeout():
	if player.health > 0:
		demon_spawner.spawn_rate -= demon_spawner.spawn_rate / 5
	else:
		timer.stop()
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _darkening_ritual():
	var tween = get_tree().create_tween()
	tween.tween_property(ritual, "modulate", Color.hex(0xfc0000), 1.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	for i in range(1, 4):
		var particles = ritual.get_node("GPUParticles2D" + ("" if i == 1 else str(i)))
		particles.emitting = false
