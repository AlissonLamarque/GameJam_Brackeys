extends Area2D

@export var speed = 400
var direction = Vector2.ZERO

func _ready():
	# Inicia a animação do projétil (ajuste o nome se necessário)
	$AnimatedSprite2D.play("fly")

func _process(delta):
	# Move o projétil na direção especificada
	position += direction * speed * delta
	
	# Remove o projétil se sair da tela
	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _on_body_entered(body):
	# Se o projétil atingir algo, ele é removido
	queue_free()
