extends Camera2D

@export var random_strength: float = 30
@export var shake_fade: float = 5

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0
var shake_speed: float = 0.0

func _ready() -> void:
	pass


func apply_shake(strength, speed):
	shake_strength = strength
	shake_speed = speed


func _physics_process(delta: float) -> void:
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta * shake_speed)
		
		offset = random_offset()

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))
