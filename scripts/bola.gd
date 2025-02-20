extends RigidBody2D
class_name Bola

@export var item_nome: String = "bola"

var picked = false


func _physics_process(delta):
	if picked == true:
		self.position = get_node("../Player/Marker2D").global_position


func _input(event):
	if Input.is_action_just_pressed("ui_pick"):
		var bodies = $Area2D.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player" and get_node("../Player").canPick == true:
				picked = true
				get_node("../Player").canPick = false

	if Input.is_action_just_pressed("ui_drop") and picked == true:
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
