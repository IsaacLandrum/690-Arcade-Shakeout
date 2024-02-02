extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_body_entered(body):
	if body is Player:
		print("shotgun")
		body.shotgun_activate()
		despawn()
		
func despawn():
	position.x = 1000
	position.y = 1000

func spawn(pos):
	global_position = pos
