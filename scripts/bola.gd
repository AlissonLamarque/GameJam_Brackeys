extends RigidBody2D
class_name Bola

@export var item_nome: String = ""

var picked = false
var target_scale = Vector2(2,2)
var can_pick = true
var original_index = z_index
@onready var audio_stream_player: AudioStreamPlayer = $AudioItemDestroy
@onready var audio_item_pickup: AudioStreamPlayer = $AudioItemPickup
@onready var audio_item_drop: AudioStreamPlayer = $AudioItemDrop

var starting_position
var initial_position_was_set = false
var has_spawned = false

var min_dissolve_rate = -1.4
var max_dissolve_rate = 1
var dissolve_rate = min_dissolve_rate

var is_base = false

@onready var largou_no_chao_timer: Timer = $Timer
@onready var player = get_node("../Player")

func _physics_process(delta):
	
	if not has_spawned:
		has_spawned = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "dissolve_rate", max_dissolve_rate, 2)
		tween.tween_callback(change_shader)
		
	
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
	
	if can_pick and has_spawned:
		$Sprite2D.material.set("shader_parameter/color", Vector4(1.0, 1.0, 1.0, 1.0))
	
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		
		if body.name != "Player":
			continue
		
		if not player.canPick:
			break
		
		if not can_pick:
			break

		$Sprite2D.material.set("shader_parameter/color", Vector4(1.0, 1.0, 0.0, 1.0))
			
		
func _input(event):
	
	if Input.is_action_pressed("ui_pick"):
		var bodies = $Area2D.get_overlapping_bodies()
		
		for body in bodies:
			if body.name == "Player" and player.canPick == true and can_pick:
				if not initial_position_was_set:
					starting_position = self.get_position()
					initial_position_was_set = true
				audio_item_pickup.play()
				picked = true
				player.canPick = false
				player.speed = player.min_speed 
				largou_no_chao_timer.stop()
	else:
		if picked:
			picked = false
			player.canPick = true
			player.speed = player.max_speed
			audio_item_drop.play()
			largou_no_chao_timer.start()
			
			# Verifica se o item foi solto perto do mago
			var mago = get_node("../Mage")
			var crafting_table = get_node("../CraftingTable")
			
			if mago and $Area2D.overlaps_body(mago):
				mago.verificar_item(item_nome)
					# Item entregue com sucesso
				destroy()  # Remove o item da cena
			
			if crafting_table and $Area2D.overlaps_body(crafting_table):
				
				if is_base:
					largou_no_chao_timer.stop()
				
				if self not in crafting_table.itens:
					
					crafting_table.itens.append(self)
					
					if crafting_table.itens.size() > 1:
						crafting_table.verify_items()
			else:
				if self in crafting_table.itens:
					crafting_table.itens.clear()
				
				#if crafting_table.is_empty():
					#crafting_table.first_item_name = item_nome
					#crafting_table.first_item = self
				#elif crafting_table.first_item_name != item_nome:
					#crafting_table.second_item = self
					#crafting_table.verify_second_item_name(item_nome)

func _ready() -> void:
	is_base = true
	item_nome = "bola"

func change_shader(shader = 1):
	dissolve_rate = min_dissolve_rate
	$Sprite2D.material.set_shader_parameter("dissolve_rate", dissolve_rate)
	if shader == 0:
		var dissolve_shader = load("res://shaders/disappear.tres")
		$Sprite2D.material.set("shader", dissolve_shader)
		$Sprite2D.material.set("shader_parameter/color", Vector3(0.888, 0.47, 0.0))
	elif shader == 1:
		var outline_shader = load("res://shaders/outline.gdshader")
		$Sprite2D.material.set("shader", outline_shader)
		$Sprite2D.material.set("shader_parameter/color", Vector4(1.0, 1.0, 1.0, 1.0))
		$Sprite2D.material.set("shader_parameter/width", 1.0)
	else:
		var appear_shader = load("res://shaders/appear.tres")
		$Sprite2D.material.set("shader", appear_shader)
		$Sprite2D.material.set("shader_parameter/color", Vector4(0.0, 0.796, 0.703, 1.0))
	
var change = true
var tween 
func destroy():
	largou_no_chao_timer.stop()
	can_pick = false
	audio_stream_player.play()
	if change:
		change = false
		change_shader(0)
		 
	tween = get_tree().create_tween()

	tween.tween_property(self, "dissolve_rate",max_dissolve_rate, 2).set_trans(Tween.TRANS_LINEAR)
	
	if is_base:
		tween.tween_callback(self.respawn)
	else:
		tween.tween_callback(self.queue_free)

func respawn():
	global_position = starting_position
	change = true
	can_pick = true
	spawn()

func spawn():
	tween = get_tree().create_tween()
	change_shader(2)
	tween.tween_property(self, "dissolve_rate", max_dissolve_rate, 2).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(self.change_shader)


func _on_timer_timeout() -> void:
	destroy()

func bola():
	pass
