extends CharacterBody2D

@export var particle_scene: PackedScene
@export var spawn_symbol_scene: PackedScene
@export var spawm_wait_time: float = 1.5
@export var speed: float = 100
@export var stop_distance: float = 10
@export var attack_damage: int = 25
@export var attack_range: float = 50
@export var player_ignore_distance: float = 50

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_parent().get_node("Player")
@onready var mage = get_parent().get_node("Mage")
@onready var camera = get_parent().get_node("Camera2D")
@onready var attack_timer: Timer = $Timer
@onready var spawn_timer: Timer = Timer.new()
@onready var som_hit: AudioStreamPlayer = $SomHit



@onready var dissolve_shader = preload("res://shaders/disappear.tres")

var target
var target_pos

var min_dissolve_rate = -1.4
var max_dissolve_rate = 1
var dissolve_rate = min_dissolve_rate

var has_spawned = false
var attacking = false

var rng = RandomNumberGenerator.new()

func _ready():
	
	var tween = get_tree().create_tween()
	$AnimatedSprite2D.material.set("shader_parameter/color", Vector3(0.888, 0.47, 0.0))
	
	tween.parallel().tween_property(self, "dissolve_rate", max_dissolve_rate, 2)
	
	add_to_group("Demon")
	
	var spawn_symbol = spawn_symbol_scene.instantiate()
	get_parent().add_child(spawn_symbol)
	spawn_symbol.global_position = global_position
	
	spawn_timer.wait_time = spawm_wait_time
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)
	spawn_timer.start()
	

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.material.set_shader_parameter("dissolve_rate", dissolve_rate)
	
	if not has_spawned:
		return
	
	var player_dist = position.distance_to(player.position)
	var mage_dist = position.distance_to(mage.position)
	
	target = null
	
	if player.player_alive == true:
		target = player 
	if mage_dist < attack_range and player_dist > player_ignore_distance and mage.is_alive == true:
		target = mage
	
	if target:
		target_pos = (target.position - position).normalized()
	
		if position.distance_to(target.position) > stop_distance and not attacking:
			position += target_pos * speed * delta
			update_animation(target_pos)
		else:
			attacking = true
			attack()
		
	

func update_animation(direction: Vector2) -> void:
	if direction.length() == 0:
		if animated_sprite.animation.begins_with("run_"):
			var idle_animation = animated_sprite.animation.replace("run_", "idle_")
			animated_sprite.play(idle_animation)
		return

	if abs(direction.x) > abs(direction.y): 
		animated_sprite.play("run_side")
		if direction.x > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		if direction.y > 0:
			animated_sprite.play("run_down")
		else:
			animated_sprite.play("run_up")

func attack():
	animated_sprite.play("attack")
	
	await animated_sprite.animation_finished
	
	if target and position.distance_to(target.position) <= attack_range and attacking:
		if target.has_method("take_damage"):  
			target.take_damage(attack_damage)
			die()
	
	attacking = false

func _on_AttackTimer_timeout():
	if target and position.distance_to(target.position) <= attack_range:
		if target.has_method("take_damage"):  
			target.take_damage(attack_damage)
			die()
	
	attacking = false

func _on_spawn_timer_timeout():
	has_spawned = true
	dissolve_rate = min_dissolve_rate
	

func die():
	$AnimatedSprite2D.material.set("shader_parameter/color", Vector3(0.0, 0.926, 0.94))
	som_hit.pitch_scale = rng.randf_range(0.9, 1.1)
	som_hit.play()
	var light = get_node("PointLight2D")
	var tween = get_tree().create_tween()
	dissolve_rate = min_dissolve_rate
	$AnimatedSprite2D.material.set("shader", dissolve_shader)
	speed = 0
	set_collision_layer_value(3, false)
	var particle = particle_scene.instantiate()
	particle.get_node("GPUParticles2D").emitting = true
	particle.global_position = global_position
	get_parent().add_child(particle)
	tween.parallel().tween_property(self, "dissolve_rate",1, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	tween.tween_callback(self.queue_free)
	
	camera.apply_shake(0.4, 2)
	
