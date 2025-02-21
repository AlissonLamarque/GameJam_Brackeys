extends Node2D

@onready var timer_item_verify: Timer = $TimerVerificaItem
@onready var timer_start_talking: Timer = $TimerStartTalking
@onready var timer_stop_talking: Timer = $TimerStopTalking
@onready var game_manager: Node2D = $"../GameManager"
@onready var camera = get_parent().get_node("Camera2D")

@onready var request_item_ui: Node = $RequestItemUI
@onready var texture_rect: TextureRect = $RequestItemUI/TextureRect

var health = 100

# Lista de itens que o mago conhece
@export var itens_conhecidos: Array[String] = ["bola", "bottle", "dagger", "rubi", "magic_book", "diamond"]
var item_pedido: String = ""
# Acima, o item que o mago está pedindo no momento


func _ready():
	timer_start_talking.start()
	request_item_ui.visible = false
	

# Função para pedir um item aleatório
func decide_item_aleatorio():
	if itens_conhecidos.size() > 0:
		item_pedido = itens_conhecidos.pop_at(randi() % itens_conhecidos.size())
		exibir_item()
	elif itens_conhecidos.size() == 0:
		game_manager.game_state = 1

func exibir_item():
	var item_texture_path = "res://assets/items/" + item_pedido + ".png"
	var item_texture = load(item_texture_path)

	if item_texture:
		texture_rect.texture = item_texture
		request_item_ui.visible = true
	else:
		print("Imagem do item não encontrada:", item_texture_path)

	print("Mago pediu:", item_pedido)

func esconder_item():
	request_item_ui.visible = false
	timer_stop_talking.start()
	print("Item correto entregue")

# Função para verificar o item entregue
func verificar_item(item_nome: String) -> bool:
	timer_item_verify.start()
	if item_nome == item_pedido:
		esconder_item()
		return true
	else:
		print("Item incorreto entregue")
		return false

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	camera.apply_shake(5, 5)

func _on_timer_item_verify_timeout() -> void:
	pass

func _on_timer_start_talking_timeout() -> void:
	decide_item_aleatorio()
	#timer iniciado no inicio do jogo


func _on_timer_stop_talking_timeout() -> void:
	decide_item_aleatorio()
	# Timer iniciado após o boneco parar de falar depois de receber um item
