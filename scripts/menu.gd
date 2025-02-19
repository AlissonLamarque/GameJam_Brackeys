extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_play_button_pressed() -> void:
	print("Iniciar Jogo")
	# Troca para a cena do jogo
	#animation_player.play("fade_out")
	#await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	#pass # Replace with function body.


func _on_config_button_pressed() -> void:
	print("Configs")
	# Troca para a cena de configurações
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/configs.tscn")
	#pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	print("Credits")
	# Troca para a cena de créditos
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	#pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	print("Sair")
	get_tree().quit()
	pass # Replace with function body.
