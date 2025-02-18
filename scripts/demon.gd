extends CharacterBody2D


@export var speed: float = 70
@export var stop_distance: float = 10

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_parent().get_node("Player")

var playerPos
var targetPos

func _physics_process(delta: float) -> void:
	playerPos = player.position
	targetPos = (playerPos - position).normalized()
	
	if position.distance_to(playerPos) > stop_distance:
		position += targetPos * speed * delta
		update_animation(targetPos)
	else:
		animated_sprite.play("idle")

func update_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animated_sprite.play("run_right")
		else:
			animated_sprite.play("run_left")
	else:
		if direction.y > 0:
			animated_sprite.play("run_down")
		else:
			animated_sprite.play("run_up")
