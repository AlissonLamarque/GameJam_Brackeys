extends RigidBody2D
class_name Bola

@export var item_nome: String = "bola"

var picked = false
var target_scale = Vector2(2,2)

var original_index = z_index

func _physics_process(delta):
	
	var staff = get_node("../Player/Staff")
	
	if picked == true:
		var muzzle1 = staff.get_node("Muzzle")
		var muzzle2 = staff.get_node("Muzzle2")
		var target_position = (muzzle1.global_position + muzzle2.global_position)/2
		self.position = lerp(self.position, target_position, 0.4)
		z_index = get_node("../Player/").z_index+1
		
		target_scale = Vector2(1,1)
		
	else:
		target_scale = Vector2(2,2)
		z_index = original_index
	
	$Sprite2D.scale = lerp($Sprite2D.scale, target_scale, 0.3)

func _input(event):
	if Input.is_action_pressed("ui_pick"):
		var bodies = $Area2D.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player" and get_node("../Player").canPick == true:
				picked = true
				get_node("../Player").canPick = false
	
	else:
		picked = false
		get_node("../Player").canPick = true
		
		# Verifica se o item foi solto perto do mago
		var mago = get_node("../Mage")
		if mago and $Area2D.overlaps_body(mago):
			if mago.verificar_item(item_nome):
				# Item entregue com sucesso
				queue_free()  # Remove o item da cena

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_nome = "bola"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
