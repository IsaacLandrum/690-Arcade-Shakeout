class_name  Asteroid extends Area2D

signal exploded(pos, size)

enum AsteroidSize{SMALL, MEDIUM, LARGE}
@export var size := AsteroidSize.LARGE


var movement_vector  := Vector2(0,-1)
var speed := 50

var points: int:
	get :
		match size:
			AsteroidSize.LARGE:
				return 100
			AsteroidSize.MEDIUM:
				return 50
			AsteroidSize.SMALL:
				return 25
			_:
				return 0

func _ready():
	var leech = get_node(".../Game")
	leech.ready.connect(leech_behavior)
	rotation = randf_range(0,2*PI)

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	# screen size variable for respawn effect at other side of screen
	var screen_size = get_viewport_rect().size
	
	# y axis screen respawn
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	
	# x axis screen respawn
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

func explode():
	emit_signal("exploded", global_position, size, points)
	queue_free()

func leech_behavior():
	print("LEECH")
func _on_body_entered(body):
	if body is Player:
		var player = body
		player.die()

