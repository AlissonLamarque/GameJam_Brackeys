extends Node2D

@onready var timer_item_verify: Timer = $TimerVerificaItem
@onready var timer_start_talking: Timer = $TimerStartTalking
@onready var timer_stop_talking: Timer = $TimerStopTalking

@onready var balao_fala = $BalaoFala
@onready var game_manager: Node2D = $"../GameManager"


# Lista de itens que o mago conhece
@export var itens_conhecidos: Array[String] = ["bola", "bottle", "dagger", "rubi", "magic_book", "diamond"]
var item_pedido: String = ""
# Acima, o item que o mago está pedindo no momento

# flag pra identificar se o item verificado foi o mesmo que o pedido
var item_estava_certo = false


func _ready():
	timer_start_talking.start()
	

# Função para pedir um item aleatório
func decide_item_aleatorio():
	if itens_conhecidos.size() > 0:
		item_pedido = itens_conhecidos.pop_at(randi() % itens_conhecidos.size())
		pedir_item()
	elif itens_conhecidos.size() == 0:
		game_manager.game_state = 1
	
func pedir_item():
	balao_fala.text = "I need  " + item_pedido + "!"
	print("Mago pediu:", item_pedido)

func agradece_item_certo():
	balao_fala.text = "Thanks!"

func reclama_item_errado():
	balao_fala.text = "Not what I wanted..."

func apaga_fala():
	balao_fala.text = ""

# Função para verificar o item entregue
func verificar_item(item_nome: String) -> bool:
	timer_item_verify.start()
	if item_nome == item_pedido:
		agradece_item_certo()
		item_estava_certo = true
		return true
	else:
		reclama_item_errado()
		return false


func _on_timer_item_verify_timeout() -> void:
	if item_estava_certo:
		apaga_fala()
		timer_stop_talking.start()
		item_estava_certo = false
	else:
		pedir_item()


func _on_timer_start_talking_timeout() -> void:
	decide_item_aleatorio()
	#timer iniciado no inicio do jogo


func _on_timer_stop_talking_timeout() -> void:
	decide_item_aleatorio()
	# Timer iniciado após o boneco parar de falar depois de receber um item
