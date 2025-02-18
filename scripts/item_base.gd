extends Node2D

signal picked_up(player)  # Sinal emitido quando o item é pego
signal dropped()          # Sinal emitido quando o item é solto

var is_held = false
var player = null

func pick_up(player_reference):
	is_held = true
	player = player_reference
	emit_signal("picked_up", player)  # Notifica que o item foi pego

func drop():
	is_held = false
	player = null
	emit_signal("dropped")  # Notifica que o item foi solto

func _process(delta):
	if is_held and player:
		global_position = player.global_position + player.get_look_direction() * 20  # Ajuste a distância
