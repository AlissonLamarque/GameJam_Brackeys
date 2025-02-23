extends Control

@export var max_health: int = 3

@onready var player = get_parent().get_node("Player")
@onready var heart_container: HBoxContainer = $HBoxContainer

var hearts = []

func _ready() -> void:
	_initialize_hearts()
	update_hearts()
	player.health_changed.connect(update_hearts)


func _initialize_hearts():
	var full_heart = preload("res://assets/UI/HeartFull.png")
	var empty_heart = preload("res://assets/UI/HeartEmpty.png")
	
	for i in range(max_health):
		var heart = TextureRect.new()
		heart.texture = full_heart
		heart.custom_minimum_size = Vector2(32, 32)
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		heart_container.add_child(heart)
		hearts.append(heart)

func update_hearts():	
	var full_heart = preload("res://assets/UI/HeartFull.png")
	var empty_heart = preload("res://assets/UI/HeartEmpty.png")
	
	for i in range(max_health):
		if i < player.health:
			print(player.health)
			hearts[i].texture = full_heart
		else:
			hearts[i].texture = empty_heart
