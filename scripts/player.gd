extends CharacterBody2D

const speed = 150.0

var dir = "right"

var health = 100
var player_alive = true
var is_moving = false
var attack_ip = null

@export var staff_distance = 40  # Distância do cajado em relação ao player
@export var bullet_scene: PackedScene  # Cena do projétil
var can_shoot = true


func _process(delta):
	if player_alive:
		rotate_staff()

		if Input.is_action_pressed("shoot") and can_shoot:
			shoot()

func rotate_staff():
	var mouse_pos = get_global_mouse_position()

	# Calcula o ângulo entre o player e o mouse
	var angle = (mouse_pos - global_position).angle()

	# Move o cajado em círculo em torno do player
	$Staff.position = Vector2(cos(angle), sin(angle)) * staff_distance

	# Faz o cajado olhar para o mouse
	$Staff.look_at(mouse_pos)

func shoot():
	can_shoot = false
	
	# Cria o projétil na posição do Muzzle
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $Staff/Muzzle.global_position
	bullet.direction = (get_global_mouse_position() - $Staff.global_position).normalized()

	get_parent().add_child(bullet)

	await get_tree().create_timer(0.2).timeout  # Taxa de tiro (0.2 segundos)
	can_shoot = true


func _ready():
	pass


func _physics_process(delta: float):
	player_movement(delta)
	play_anim()
	
	if health <= 0:
		player_alive = false
		health = 0
		self.queue_free()
	

func player_movement(delta):
	
	var dir_x = Input.get_axis("move_left", "move_right")
	var dir_y = Input.get_axis("move_up", "move_down")
	
	if dir_x > 0:
		dir = "right"
	elif dir_x < 0:
		dir = "left"
	
	if dir_y > 0:
		dir = "down"
	elif dir_y < 0:
		dir = "up"
	
	velocity = Vector2(dir_x, dir_y).normalized() * speed
	move_and_slide()


func play_anim():
	var anim = $AnimatedSprite2D
	anim.flip_h = dir == "left"
	
	if dir == "left" or dir == "right":
		if abs(velocity.x) > 0:
			anim.play("walk_side")
			is_moving = true
		else:
			if not attack_ip:
				is_moving = false
				anim.play("idle_side")
	
	if dir == "up" or dir == "down":
		var side = "_back" if dir == "up" else "_front"

		if abs(velocity.y) > 0:
			is_moving = true
			anim.play("walk"+side)
		else:
			if not attack_ip:
				is_moving = false
				anim.play("idle"+side)

func player():
	pass
	
