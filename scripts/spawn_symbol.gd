extends Node2D

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var som_spawn: AudioStreamPlayer = $somSpawn

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	som_spawn.pitch_scale = rng.randf_range(0.9, 1.1)
	som_spawn.play()
	animation_player.play("rotate")
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
