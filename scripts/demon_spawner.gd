extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_rate: float = 0.6
@export var spawn_area: Area2D
@export var no_spawn_area: Area2D

func _ready():
	start_spawning()
	
func start_spawning():
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_rate
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(spawn_enemy)
	add_child(spawn_timer)

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
	var shape: CollisionShape2D = no_spawn_area.get_node_or_null("CollisionShape2D")

	if shape and shape.shape is RectangleShape2D:
		var rect = shape.shape.extents
		var area_pos = no_spawn_area.global_position
		var local_pos = pos - area_pos

		return (abs(local_pos.x) <= rect.x and abs(local_pos.y) <= rect.y)

	return false

func get_random_position_within(area: Area2D) -> Vector2:
	var shape: CollisionShape2D = area.get_node_or_null("CollisionShape2D")
	
	if not shape:
		print("Erro: CollisionShape2D não encontrado dentro de ", area.name)
		return Vector2.ZERO

	if shape.shape is RectangleShape2D:
		var rect = shape.shape.extents
		var pos = area.global_position
		return pos + Vector2(randf_range(-rect.x, rect.x), randf_range(-rect.y, rect.y))

	print("Erro: Shape não é RectangleShape2D!")
	return Vector2.ZERO
