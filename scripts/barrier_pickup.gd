extends Area2D


## Called when the node enters the scene tree for the first time.
func _ready():
	print("works")
	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_body_entered(body):
	if body is Player:
		body.barrier_activate()
		print("Entered")
		despawn()
		
func despawn():
	position.x = 1000
	position.y = 1000

func spawn(pos):
	global_position = pos
