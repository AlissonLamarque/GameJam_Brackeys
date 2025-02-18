extends Area2D

@export var speed = 400
var direction = Vector2.ZERO

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta: float):
	position += direction * speed * delta

func _on_body_entered(body):
	queue_free()
