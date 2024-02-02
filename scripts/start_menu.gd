extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("shoot"):
		start_game()

func start_game():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
