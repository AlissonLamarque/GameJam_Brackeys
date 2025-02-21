extends StaticBody2D

@export var first_item_name = ""
@export var second_item_name = ""

@export var first_item = null
@export var second_item = null

@export var base_items: Array[String] = ["bola", "bottle", "dagger", "rubi", "magic_book", "diamond"]
@export var made_items: Array[String] = [
"blue_potion", "diamond_scroll", "diamond_skull", "eldritch_dagger",
"fire_dagger", "golden_book", "golden_potion", "golden_skull", 
"herbs_potion", "herbs_rubi", "herbs_scroll", "herb_dagger",
"ice_dagger", "red_potion", "rubi_scroll", "skull_dagger",
"skull_scroll"
]

var new_item_scene_path = ""

@onready var timer_consome_itens: Timer = $TimerConsomeItens

var item_estava_certo = false

func is_empty():
	if first_item_name == "":
		return true
	else:
		return false

func verify_second_item_name(item_nome: String):
	if item_nome in base_items:
		timer_consome_itens.start()
		second_item_name = item_nome

func _ready():
	#timer_start_talking.start()
	pass
	
func combine_items(item1: String, item2: String) -> String:
	#junta itens pra fazer item novo ou nao faz nada se combinacao nao existe
	var new_item_name = "fire_dagger"
	first_item_name = ""
	second_item_name = ""
	print(new_item_name)
	return new_item_name

func spawn_item():
	if new_item_scene_path:
		var new_item_packed_scene = load(new_item_scene_path)
		var new_item = new_item_packed_scene.instantiate()
		new_item.global_position = global_position
		new_item.global_position.y = global_position.y - 50
		get_parent().add_child(new_item)

func _on_timer_consome_itens_timeout() -> void:
	if first_item:
		first_item.destroy()
	if second_item:
		second_item.destroy()
		pass
	first_item = null
	second_item = null
	
	var new_item_name = combine_items(first_item_name, second_item_name)
	if new_item_name:
		new_item_scene_path = "res://scenes/made_items/" + new_item_name + ".tscn"
		spawn_item()
