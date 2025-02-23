extends CharacterBody2D

var max_speed = 150.0
var min_speed = 150.0/1.5
var speed = max_speed

@onready var game_manager: Node2D = $"../GameManager"
@onready var camera = get_parent().get_node("Camera2D")

var rng = RandomNumberGenerator.new()

var health = 3
var player_alive = true
var is_moving = false
var is_taking_damage = false

const crosshair_distance = 20

@export var staff_distance = 1
@export var bullet_scene: PackedScene
var can_shoot = true

var initial_light_scale = 0

var staff_position_offset = Vector2.ZERO
var staff_position_target = Vector2.ZERO
var canPick = true

func get_look_direction():
	var mouse_pos = get_global_mouse_position()
	
	return global_position.direction_to(mouse_pos).normalized()

func _ready():
	add_to_group("player")
	initial_light_scale = $Staff/PointLight2D.scale

func _process(delta):
	if player_alive:
		rotate_staff(delta)

		if Input.is_action_pressed("shoot") and can_shoot:
			if canPick:
				shoot()
	else:
		$Staff.visible = false

func rotate_staff(delta):
	if !player_alive:
		return
	
	var light = $Staff/PointLight2D
	
	var angle = get_look_direction()
	
	if angle.x > 0:
		$Staff/Sprite2D.flip_v = false
		light.position = $Staff/Muzzle.position
		
	else:
		$Staff/Sprite2D.flip_v = true
		light.position = $Staff/Muzzle2.position
		
	
	staff_position_offset = lerp(staff_position_offset, staff_position_offset.move_toward(staff_position_target, delta), 0.7)
	
	var interval = 2
	
	if staff_position_offset.is_equal_approx(staff_position_target):
		staff_position_target = Vector2(rng.randf_range(-interval, interval), rng.randf_range(-interval, interval))
	
	$Staff.position = (angle * staff_distance) + staff_position_offset
	
	$Staff.look_at(get_global_mouse_position())

func shoot():
	if !player_alive:
		return
		
	can_shoot = false
	
	$Staff/PointLight2D.scale = initial_light_scale * 2.5
	
	var bullet = bullet_scene.instantiate()
	
	var muzzle = $Staff/Muzzle
	
	if $Staff/Sprite2D.flip_v:
		muzzle = $Staff/Muzzle2
	
	bullet.global_position = muzzle.global_position
	bullet.direction = (get_global_mouse_position() - muzzle.global_position).normalized()
	
	bullet.connect("hit_target", Callable(self, "_on_bullet_hit"))
	
	get_parent().add_child(bullet)

	await get_tree().create_timer(0.5).timeout

	can_shoot = true

func _on_bullet_hit(body):
	if body.is_in_group("Demon"):
		body.die()

func _physics_process(delta: float):
	player_movement(delta)
	play_anim()
	
	var light = $Staff/PointLight2D
	
	light.scale = lerp(light.scale, initial_light_scale, 0.07)
	
	$Staff.visible = true
	
	if not canPick:
		$Staff.visible = false

func player_movement(delta):
	var dir_x = Input.get_axis("move_left", "move_right")
	var dir_y = Input.get_axis("move_up", "move_down")
	
	velocity = Vector2(dir_x, dir_y).normalized() * speed
	
	is_moving = false
	
	if not velocity.is_zero_approx():
		is_moving = true
	
	move_and_slide()

func play_anim():
	var anim = $AnimatedSprite2D

	var angle = get_look_direction()
	
	var dir = null
	
	if (angle.x > 0 or angle.x < 0) and (angle.y > -0.5 and angle.y < 0.5):
		dir = "side"
	else:
		if angle.y > 0:
			dir = "front"
		else:
			dir = "back"
			

	if angle.x > 0:
		anim.flip_h = false
	else:
		anim.flip_h = true
	
	if is_moving:
		anim.play("walk_"+dir)
		
	else:
		anim.play("idle_"+dir)
	
	#if is_taking_damage:
		#anim.play("hurt_"+dir)
		#await anim.animation_finished
		#is_taking_damage = false

func player():
	pass
	
func take_damage(amount: int):
	is_taking_damage = true
	health -= amount
	camera.apply_shake(200, 0.1)
	if health <= 0:
		die()

func die():
	camera.apply_shake(5, 5)
	speed = 0
	player_alive = false
	game_manager.game_state = 6
