extends CharacterBody2D

@export var speed: float = 70
@export var stop_distance: float = 10
@export var particle_scene: PackedScene

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_parent().get_node("Player")

@onready var camera = get_parent().get_node("Camera2D")

var player_pos
var target_pos

var dissolve_rate = -1.14

func _ready():
	add_to_group("Demon")

func _physics_process(delta: float) -> void:
	player_pos = player.position
	target_pos = (player_pos - position).normalized()
	if position.distance_to(player_pos) > stop_distance:
		position += target_pos * speed * delta
		update_animation(target_pos)
	else:
		animated_sprite.play("idle")
	
	$AnimatedSprite2D.material.set_shader_parameter("dissolve_rate", dissolve_rate)

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

func die():
	var light = get_node("PointLight2D")
	var tween = get_tree().create_tween()
	
	speed = 0
	set_collision_layer_value(3, false)
	#animated_sprite.visible = false
	# Trecho para brilho de morte do demon
	#light.visible = true
	var particle = particle_scene.instantiate()
	particle.get_node("GPUParticles2D").emitting = true
	particle.global_position = global_position
	get_parent().add_child(particle)
	tween.parallel().tween_property(self, "dissolve_rate",1, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	#tween.parallel().tween_property(light, "texture_scale", 0.3, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	#tween.parallel().tween_property(light, "energy", 0, 0.15)
	
	tween.tween_callback(self.queue_free)
	
	camera.apply_shake(0.4, 2)
	
