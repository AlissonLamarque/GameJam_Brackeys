extends CharacterBody2D

@export var speed: float = 70
@export var stop_distance: float = 10
@export var attack_damage: int = 40
@export var attack_cooldown: float = 10
var teste: float = 3

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $Timer

@onready var player = get_parent().get_node("Player")
@onready var camera = get_parent().get_node("Camera2D")

var player_pos
var target_pos

func _ready():
	add_to_group("Demon")
	attack_timer.wait_time = attack_cooldown
	attack_timer.start()

func _physics_process(delta: float) -> void:
	player_pos = player.position
	target_pos = (player_pos - position).normalized()
	
	if position.distance_to(player_pos) > stop_distance:
		position += target_pos * speed * delta
		update_animation(target_pos)
	else:
		animated_sprite.play("idle")

func update_animation(direction: Vector2) -> void:
	if direction.length() == 0:
		if animated_sprite.animation.begins_with("run_"):
			var idle_animation = animated_sprite.animation.replace("run_", "idle_")
			animated_sprite.play(idle_animation)
		return

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

func _on_AttackTimer_timeout():
	if position.distance_to(player.position) <= stop_distance:
		player.visible = false
		attack_timer.wait_time = teste
		player.take_damage(attack_damage)
		player.visible = true

func die():
	var light = get_node("PointLight2D")
	var tween = get_tree().create_tween()
	
	speed = 0
	animated_sprite.visible = false
	# Trecho para brilho de morte do demon
	light.visible = true
	tween.tween_property(light, "texture_scale", 0.35, 0.15)
	tween.tween_property(light, "color", Color.hex(0xfa000000), 0.15)
	tween.tween_property(light, "energy", 0, 0.15)
	
	camera.apply_shake(0.4, 2)
	
	await get_tree().create_timer(0.15).timeout
	
	queue_free()
