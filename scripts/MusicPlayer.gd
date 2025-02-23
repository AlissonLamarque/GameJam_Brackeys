extends AudioStreamPlayer


func _ready():
	stream = load("res://assets/sounds/MusicaBrackeysGameJogoJam.wav")  # Substitua pelo caminho correto
	volume_db = 1  # Ajuste o volume se necessário
	play()  # Começa a tocar
