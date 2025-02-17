extends CharacterBody2D

const speed = 150.0

var dir = "right"

var health = 100
var player_alive = true
var is_moving = false
var attack_ip = null

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
	
