extends CharacterBody2D

@export var particle_scene: PackedScene
@export var speed: float = 70
@export var stop_distance: float = 10
@export var attack_damage: int = 25
@export var attack_cooldown: float = 3
@export var attack_range: float = 50
@export var player_ignore_distance: float = 50

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_parent().get_node("Player")
@onready var mage = get_parent().get_node("Mage")
@onready var camera = get_parent().get_node("Camera2D")
@onready var attack_timer: Timer = $Timer

var target
var target_pos

var dissolve_rate = -1.14

func _ready():
	add_to_group("Demon")
	attack_timer.wait_time = attack_cooldown
	attack_timer.start()

func _physics_process(delta: float) -> void:
	var player_dist = position.distance_to(player.position)
	var mage_dist = position.distance_to(mage.position)
	
	target = player
	if mage_dist < attack_range and player_dist > player_ignore_distance:
		target = mage
		
	target_pos = (target.position - position).normalized()
	
	if position.distance_to(target.position) > stop_distance:
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

func _on_AttackTimer_timeout():
	if target and position.distance_to(target.position) <= attack_range:
		if target.has_method("take_damage"):  
			target.take_damage(attack_damage)
			camera.apply_shake(1, 2)
			die()
	attack_timer.start()

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
	
