extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_rate: float = 0.6
@export var spawn_area: Area2D
@export var no_spawn_area: Area2D
@onready var spawn_timer: Timer = $SpawnTimer

func _ready():
	start_spawning()

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
	spawn_timer.wait_time = spawn_rate


func start_spawning():
	spawn_timer.start()


func spawn_enemy():
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.global_position = get_valid_spawn_position()
		get_parent().get_parent().add_child(enemy)

func get_valid_spawn_position() -> Vector2:
	var max_attempts = 10
	var spawn_position = Vector2.ZERO

	for i in range(max_attempts):
		spawn_position = get_random_position_within(spawn_area)
		if not is_in_no_spawn_area(spawn_position):
			return spawn_position
	
	return get_random_position_within(spawn_area)

func is_in_no_spawn_area(pos: Vector2) -> bool:
	var shape: CollisionShape2D = no_spawn_area.get_node_or_null("CollisionShape2D_NoSpawn")

	if shape and shape.shape is RectangleShape2D:
		var rect = shape.shape.extents
		var area_pos = shape.global_position
		var local_pos = pos - area_pos

		return (abs(local_pos.x) <= rect.x and abs(local_pos.y) <= rect.y)

	return false

func get_random_position_within(area: Area2D) -> Vector2:
	var shape: CollisionShape2D = area.get_node_or_null("CollisionShape2D_Spawn")
	
	if shape.shape is RectangleShape2D:
		var rect = shape.shape.extents
		var pos = shape.global_position 
		var offset = Vector2(randf_range(-rect.x, rect.x), randf_range(-rect.y, rect.y))
		return pos + offset

	return Vector2.ZERO
