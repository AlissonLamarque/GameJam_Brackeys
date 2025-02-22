extends StaticBody2D

@export var first_item_name = ""
@export var second_item_name = ""

@export var first_item = null
@export var second_item = null
@onready var area_2d: Area2D = $Area2D

@export var base_items: Array[String] = ["bola", "bottle", "dagger", "rubi", "magic_book", "diamond"]
@export var made_items: Array[String] = [
"blue_potion", "diamond_scroll", "diamond_skull", "eldritch_dagger",
"fire_dagger", "golden_book", "golden_potion", "golden_skull", 
"herbs_potion", "herbs_rubi", "herbs_scroll", "herb_dagger",
"ice_dagger", "red_potion", "rubi_scroll", "skull_dagger",
"skull_scroll"
]

const combinacoes = {
	"dagger,rubi":"fire_dagger",
	"rubi,dagger":"fire_dagger",
	"rubi,bottle":"red_potion",
	"bottle,rubi":"red_potion",
	"diamond,bottle":"blue_potion",
	"bottle,diamong":"blue_potion",
	"herbs,bottle":"herbs_potion",
	"bottle,herbs":"herbs_potion",
	"golden_feather,bottle":"golden_potion",
	"bottle,golden_feather":"golden_potion",
	"diamond,dagger":"ice_dagger",
	"dagger,diamond":"ice_dagger",
	"skull,dagger":"skull_dagger",
	"dagger,skull":"skull_dagger",
	"bola,dagger":"eldritch_dagger",
	"dagger,bola":"eldritch_dagger",
	"dagger,herbs":"herb_dagger",
	"herbs,dagger":"herb_dagger",
	"diamond,magic_book":"diamond_scroll",
	"magic_book,diamond":"diamond_scroll",
	"diamond,skull":"diamond_skull",
	"skull,diamond":"diamond_skull",
	"golden_feather,skull":"golden_skull",
	"skull,golden_feather":"golden_skull",
	"herbs,rubi":"herbs_rubi",
	"rubi,herbs":"herbs_rubi",
	"herbs,magic_book":"herbs_scroll",
	"magic_book,herbs":"herbs_scroll",
	"rubi,magic_book":"rubi_scroll",
	"magic_book,rubi":"rubi_scroll",
	"skull,magic_book":"skull_scroll",
	"magic_book,skull":"skull_scroll",
	#"golden_feather,dagger":"golden_dagger",
	#"dagger,golden_feather":"golden_dagger",
	"magic_book,golden_feather":"golden_book",
	"golden_feather,magic_book":"golden_book",
	"bola,magic_book":"bola_scroll",
	"magic_book,bola":"bola_scroll",
	"bola,skull":"bola_skull",
	"skull,bola":"bola_skull",
	"bola,bottle":"bola_potion",
	"bottle,bola":"bola_potion",
}

var new_item_scene_path = ""

@onready var timer_consome_itens: Timer = $TimerConsomeItens
@onready var timer_pode_spawnar: Timer = $TimerPodeSpawnar
@onready var timer_garante_items_null: Timer = $TimerGaranteItemsNull

var item_estava_certo = false

var can_spawn = true

func is_empty():
	if first_item_name == "":
		return true
	else:
		return false

func verify_second_item_name(item_nome: String):
	if item_nome in base_items:
		if item_nome != first_item_name:
			timer_consome_itens.start()
			second_item_name = item_nome

func _ready():
	#timer_start_talking.start()
	pass
	
func combine_items(item1: String, item2: String) -> String:
	#junta itens pra fazer item novo ou nao faz nada se combinacao nao existe
	var truncated_name = item1 + "," + item2
	var new_item_name = ""
	if truncated_name in combinacoes:
		new_item_name = combinacoes[truncated_name]
	else:
		new_item_name = ""
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
	if not can_spawn:
		return
	
	var new_item_name = combine_items(first_item_name, second_item_name)
	if new_item_name != "":
		new_item_scene_path = "res://scenes/made_items/" + new_item_name + ".tscn"
		spawn_item()
	can_spawn = false
	
	timer_garante_items_null.start()
	if first_item:
		first_item.destroy()
	if second_item:
		second_item.destroy()
	first_item_name = ""
	second_item_name = ""
	first_item = null
	second_item = null
	
	timer_pode_spawnar.start()


func _on_timer_pode_spawnar_timeout() -> void:
	can_spawn = true
	pass # Replace with function body.

#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#var close_items = area_2d.get_overlapping_bodies()
	#
	#if first_item == null:
		#first_item = 
	#pass # Replace with function body.


func _on_timer_garante_items_null_timeout() -> void:
	first_item = null
	second_item = null
	first_item_name = ""
	second_item_name = ""
