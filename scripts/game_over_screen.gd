extends Control

func _on_restart_button_pressed():
	print("ButtonPressed")
	get_tree().reload_current_scene()
