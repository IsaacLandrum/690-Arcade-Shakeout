extends CharacterBody2D

signal exploded(pos, size)

var movement_vector  := Vector2(1,0)
var speed := 75

var timer := Timer.new()

var points := 200

var movement_angle := 0

func _ready():
	rotation = randf_range(0,2*PI)

func shot():
	queue_free()

func setMovement(location):
	match location:
		"top":
			#Move down
			movement_angle = randf_range(0,PI)
		"bottom":
			#Move up
			movement_angle = randf_range(PI,2*PI)
		"left":
			#Move right
			movement_angle = randf_range(3*PI/2,5*PI/2)
		"right":
			#Move left
			movement_angle = randf_range(PI/2,3*PI/2)
		_:
			pass

func setRotation(playerPos):
	pass

func spawn():
	var spawnLocations = ["top", "bottom", "left", "right"]
	#Randomly choose spawn location
	var choice = spawnLocations[randi() % spawnLocations.size()]
	
	var screen_size = get_viewport_rect().size
	match choice:
		"top":
			position.x = (screen_size.x) / 2
			position.y = -20
			setMovement("top")
		"bottom":
			position.x = (screen_size.x) / 2
			position.y = (screen_size.y) + 20
			setMovement("bottom")
		"left":
			position.x = 20
			position.y = (screen_size.y) / 2
			setMovement("left")
		"right":
			position.x = (screen_size.x) + 20
			position.y = (screen_size.y) / 2
			setMovement("right")
		_:
			pass
	

func despawn():
	position.x = 1000
	position.y = 1000

func _on_timer_timeout():
	despawn()

func _physics_process(delta):
	global_position += movement_vector.rotated(movement_angle) * speed * delta

func _on_body_entered(body):
	if body is Player:
		var player = body
		player.die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
