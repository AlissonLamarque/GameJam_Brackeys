extends Node2D

@onready var timer_item_verify: Timer = $TimerVerificaItem
@onready var timer_start_talking: Timer = $TimerStartTalking
@onready var timer_stop_talking: Timer = $TimerStopTalking
@onready var game_manager: Node2D = $"../GameManager"
@onready var camera = get_parent().get_node("Camera2D")

@onready var request_item_ui: Node = $RequestItemUI
@onready var texture_rect: TextureRect = $RequestItemUI/TextureRect

@export var MAX_HEALTH = 3
var health = MAX_HEALTH
var is_alive = true

# Lista de itens que o mago conhece
@export var itens_conhecidos: Array[String] = ["bola", "bottle", "dagger", "rubi", "magic_book", "diamond"]
@export var made_items: Array[String] = [
"blue_potion", "diamond_scroll", "diamond_skull", "eldritch_dagger",
"fire_dagger", "golden_book", "golden_potion", "golden_skull", 
"herbs_potion", "herbs_rubi", "herbs_scroll", "herb_dagger",
"ice_dagger", "red_potion", "rubi_scroll", "skull_dagger",
"skull_scroll", "bola_potion", "bola_scroll", "bola_skull"
]
var item_pedido: String = ""
# Acima, o item que o mago está pedindo no momento

var balao_time = 0

func _ready():
	timer_start_talking.start()
	request_item_ui.visible = false
	

# Função para pedir um item aleatório
func decide_item_aleatorio():
	if itens_conhecidos.size() > 0:
		item_pedido = made_items.pop_at(randi() % made_items.size())
		exibir_item()
	if made_items.size() == 0:
		game_manager.game_state = 4
	elif made_items.size() == 1:
		game_manager.game_state = 3
	elif made_items.size() <= 5:
		game_manager.game_state = 2
	elif made_items.size() <= 15:
		game_manager.game_state = 1
		

func exibir_item():
	var item_texture_path = "res://assets/items/" + item_pedido + ".png"
	var item_texture = load(item_texture_path)

	if item_texture:
		texture_rect.texture = item_texture
		request_item_ui.visible = true
	else:
		print("Imagem do item não encontrada:", item_texture_path)

func esconder_item():
	request_item_ui.visible = false
	timer_stop_talking.start()

# Função para verificar o item entregue
func verificar_item(item_nome: String) -> bool:
	if health <= 0:
		return false
	
	timer_item_verify.start()
	if item_nome == item_pedido:
		esconder_item()
		return true
	else:
		game_manager.game_state = 2  # Muitos demonios vindo
		return false

func take_damage(amount: int):
	health -= amount
	if health <= MAX_HEALTH/2:
		game_manager.game_state = 2  # Muitos demonios vindo
	if health <= 0:
		die()

func die():
	camera.apply_shake(5, 5)
	request_item_ui.visible = false
	is_alive = false
	game_manager.game_state = 5  # Fim de jogo, Derrota
	

func _physics_process(delta: float) -> void:
	var balao = $RequestItemUI/NinePatchRect
	var texture = $RequestItemUI/TextureRect
	balao.position.y = lerp(balao.position.y, balao.position.y+cos(deg_to_rad(balao_time*2))/5, 0.4)
	texture.position.y = balao.position.y+5
	
	balao_time += 1
	balao_time = balao_time%360
	
func _on_timer_item_verify_timeout() -> void:
	pass

func _on_timer_start_talking_timeout() -> void:
	decide_item_aleatorio()
	#timer iniciado no inicio do jogo


func _on_timer_stop_talking_timeout() -> void:
	decide_item_aleatorio()
	# Timer iniciado após o boneco parar de falar depois de receber um item
