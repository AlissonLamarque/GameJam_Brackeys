extends StaticBody2D

@export var first_item_name = ""
@export var second_item_name = ""

@export var first_item = null
@export var second_item = null
@onready var area_2d: Area2D = $Area2D

var itens = []
var names = []

@export var base_items: Array[String] = ["bola", "bottle", "dagger", "rubi", "magic_book", "diamond", "herbs", "golden_feather", "skull"]
@export var made_items: Array[String] = [
"blue_potion", "diamond_scroll", "diamond_skull", "eldritch_dagger",
"fire_dagger", "golden_book", "golden_potion", "golden_skull", 
"herbs_potion", "herbs_scroll", "herb_dagger",
"ice_dagger", "red_potion", "rubi_scroll", "skull_dagger",
"skull_scroll"
]

const combinacoes = {
	"bola,bottle":"bola_potion",
	"bola,dagger":"eldritch_dagger",
	"bola,magic_book":"bola_scroll",
	"bola,skull":"bola_skull",
	"bottle,diamond":"blue_potion",
	"bottle,golden_feather":"golden_potion",
	"bottle,herbs":"herbs_potion",
	"bottle,rubi":"red_potion",
	"dagger,diamond":"ice_dagger",
	"dagger,herbs":"herb_dagger",
	"dagger,rubi":"fire_dagger",
	"dagger,skull":"skull_dagger",
	"diamond,magic_book":"diamond_scroll",
	"diamond,skull":"diamond_skull",
	"golden_feather,magic_book":"golden_book",
	"golden_feather,skull":"golden_skull",
	"herbs,magic_book":"herbs_scroll",
	"magic_book,rubi":"rubi_scroll",
	"magic_book,skull":"skull_scroll",
}

var new_item_scene_path = ""

@onready var timer_spawn_item: Timer = $TimerSpawnItem

		
func empty_crafting_table():
	for item in itens:
		item.destroy()
			
	itens = []

func verify_items():
	if itens[0].item_nome in base_items and itens[1].item_nome in base_items:
		timer_spawn_item.start()
		
		for item in itens:
			names.append(item.item_nome)
		
		print(names)
		names.sort()
		print(names)
		
		empty_crafting_table()

	
func combine_items(item1: String, item2: String) -> String:
	var truncated_name = item1 + "," + item2
	var new_item_name = ""
	
	if truncated_name in combinacoes:
		new_item_name = combinacoes[truncated_name]
	else:
		new_item_name = ""
		empty_crafting_table()
		
	return new_item_name

func _on_timer_spawn_item_timeout() -> void:
	var new_item_name = combine_items(names[0], names[1])
	names.clear()
	if new_item_name != "":
		new_item_scene_path = "res://scenes/made_items/" + new_item_name + ".tscn"
		
		var new_item_packed_scene = load(new_item_scene_path)
		var new_item = new_item_packed_scene.instantiate()
		new_item.global_position = global_position
		new_item.global_position.y = global_position.y
		get_parent().add_child(new_item)
		
