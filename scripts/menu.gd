extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_play_button_pressed() -> void:
	print("Iniciar Jogo")
	# Troca para a cena do jogo
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	#pass # Replace with function body.


func _on_config_button_pressed() -> void:
	print("Configs")
	# Troca para a cena de configurações
	
	get_tree().change_scene_to_file("res://scenes/configs.tscn")
	#pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	print("Credits")
	# Troca para a cena de créditos
	
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	#pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	print("Sair")
	get_tree().quit()
	pass # Replace with function body.
