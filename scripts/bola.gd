extends RigidBody2D
class_name Bola

@export var item_nome: String = ""

var picked = false
var target_scale = Vector2(2,2)
var can_pick = true
var original_index = z_index

var shader = preload("res://shaders/disappear.tres")

var dissolve_rate = -1.4

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
	$Sprite2D.material.set_shader_parameter("dissolve_rate", dissolve_rate)

func _input(event):
	
	var player = get_node("../Player")
	
	if Input.is_action_pressed("ui_pick"):
		var bodies = $Area2D.get_overlapping_bodies()
		
		for body in bodies:
			if body.name == "Player" and player.canPick == true and can_pick:
				picked = true
				player.canPick = false
				player.speed = player.min_speed 
	else:
		picked = false
		player.canPick = true
		player.speed = player.max_speed
		
		# Verifica se o item foi solto perto do mago
		var mago = get_node("../Mage")
		var crafting_table = get_node("../CraftingTable")
		
		if mago and $Area2D.overlaps_body(mago):
			if mago.verificar_item(item_nome):
				# Item entregue com sucesso
				destroy()  # Remove o item da cena
		elif crafting_table and $Area2D.overlaps_body(crafting_table):
			if crafting_table.is_empty():
				crafting_table.first_item_name = item_nome
				crafting_table.first_item = self
			elif crafting_table.first_item_name != item_nome:
				crafting_table.second_item = self
				crafting_table.verify_second_item_name(item_nome)
			
				

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_nome = "bola"
	pass # Replace with function body.

var tween

var change = true

func destroy():
	can_pick = false
	
	if change:
		change = false
		$Sprite2D.material.set("shader", shader)
		$Sprite2D.material.set("shader_parameter/color", Vector3(0.888, 0.47, 0.0))
		 

	tween = get_tree().create_tween()
	tween.tween_property(self, "dissolve_rate",1, 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(self.free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
