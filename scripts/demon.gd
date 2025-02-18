extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../Player"
@export var speed: float = 100
@export var stop_distance: float = 10

func _physics_process(delta: float) -> void:
	if player:
		var distance = global_position.distance_to(player.global_position)

		if distance > stop_distance: 
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
			look_at(player.global_position)
		else:
			velocity = Vector2.ZERO
