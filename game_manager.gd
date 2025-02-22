extends Node2D

@export var game_state = 0
@onready var demon_spawner = get_node("DemonSpawner")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_state == 0:
		demon_spawner.spawn_rate = 4.0
	elif game_state == 1:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		demon_spawner.spawn_rate = 0.3
