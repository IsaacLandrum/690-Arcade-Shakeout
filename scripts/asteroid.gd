extends Area2D
	
var movement_vector  := Vector2(0,-1)
var speed := 50 	

func _ready():
	rotation = randf_range(0,2*PI)


func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta
