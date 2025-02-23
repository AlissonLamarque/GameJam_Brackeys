extends Node2D

var index = 0
@onready var label: Label = $Label
@onready var change_dialog_timer: Timer = $ChangeDialog

var dialogs = [
	"The time has come, my apprentice...",
	"The demon army is trying\nto destroy our kingdom...",
	"You'll have to help me complete\nthe ritual to stop them",
	"Use our arcane fusion table\nto create and hand me\nthe ritual components",
	"They will try to attack me",
	"You have to stop them.",
	"If anything go wrong,\nit's the end of our kingdom...",
	"I trust you."
]

func change_dialog():
	var tween = get_tree().create_tween()
	tween.tween_property(label, "label_settings:color", Vector3(0.0, 0.0, 0.0), 1)
	tween.tween_callback(change_text)

func end_cutscene():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

	
func change_text():
	label.text = dialogs[index]
	var tween = get_tree().create_tween()
	tween.tween_property(label, "label_settings:color", Vector3(1.0, 1.0, 1.0), 1)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		change_dialog()
		change_dialog_timer.start()
		index += 1
		

func _on_change_dialog_timeout() -> void:
	if index < dialogs.size()-1:
		change_dialog()
		index += 1
	else:
		end_cutscene()
