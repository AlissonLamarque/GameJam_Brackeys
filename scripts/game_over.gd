extends Node2D


func _on_play_button_pressed() -> void:
	# Troca para a cena do jogo
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_config_button_pressed() -> void:
	# Troca para a cena de configurações
	get_tree().change_scene_to_file("res://scenes/configs.tscn")


func _on_credits_button_pressed() -> void:
	# Troca para a cena de créditos
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_exit_button_pressed() -> void:
	# Termina o jogo
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
