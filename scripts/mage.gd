extends Node2D

@onready var timer: Timer = $Timer
@onready var balao_fala = $BalaoFala


# Lista de itens que o mago conhece
@export var itens_conhecidos: Array[String] = ["bola", "bottle", "dagger", "rubi", "magic_book", "diamond"]
var item_pedido: String = ""
# Acima, o item que o mago está pedindo no momento

# flag pra identificar se o item verificado foi o mesmo que o pedido
var item_estava_certo = false


func _ready():
	decide_item_aleatorio()

# Função para pedir um item aleatório
func decide_item_aleatorio():
	item_pedido = itens_conhecidos[randi() % itens_conhecidos.size()]
	pedir_item()
	
func pedir_item():
	balao_fala.text = "I need  " + item_pedido + "!"
	print("Mago pediu:", item_pedido)

func agradece_item_certo():
	balao_fala.text = "Obrigado! Era isso mesmo."

func reclama_item_errado():
	balao_fala.text = "Isso não é o que eu pedi..."
	

# Função para verificar o item entregue
func verificar_item(item_nome: String) -> bool:
	timer.start()
	if item_nome == item_pedido:
		agradece_item_certo()
		item_estava_certo = true
		return true
	else:
		reclama_item_errado()
		return false


func _on_timer_timeout() -> void:
	if item_estava_certo:
		decide_item_aleatorio()
		item_estava_certo = false
	else:
		pedir_item()
	pass # Replace with function body.
