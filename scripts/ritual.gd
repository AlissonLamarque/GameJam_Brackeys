extends Sprite2D

@onready var point_light_2d: PointLight2D = $PointLight2D


var min_energy = 1.0
var max_energy = 4.0
var target_energy = max_energy


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	
	var actual_energy = point_light_2d.energy
	
	if is_equal_approx(actual_energy, target_energy):
		
		if target_energy == max_energy:
			target_energy = min_energy
		else:
			target_energy = max_energy
		
	point_light_2d.energy = lerp(actual_energy, move_toward(actual_energy, target_energy, delta/1.5), 0.5)


	
	
