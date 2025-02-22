extends Node2D

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("rotate")
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
