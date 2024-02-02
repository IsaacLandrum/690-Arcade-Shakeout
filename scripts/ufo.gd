class_name UFO extends Area2D

signal projectile_shot(projectile)
signal is_shot(points)

var movement_vector  := Vector2(1,0)
var speed := 75
var movement_angle := 0

var points := 200

@onready var muzzle = $Muzzle
@onready var sprite = $Sprite2D

var projectile_scene = preload("res://scenes/ufo_projectile.tscn")

func _ready():
	startFiringLoop()

func startFiringLoop():
	var timer = get_node("Timer")
	timer.timeout.connect(_fire_projectile)
	timer.wait_time = 2
	timer.start()

func _fire_projectile():
	var p = projectile_scene.instantiate()
	p.global_position = muzzle.global_position
	p.rotation = rotation + PI
	var screen_size = get_viewport_rect().size
	if (
		position.x < screen_size.x &&
		position.x > 0 &&
		position.y < screen_size.y &&
		position.y > 0
	):
		emit_signal("projectile_shot", p)
	startFiringLoop()

func setRotation(playerPos):
	var direction = playerPos - global_position
	var angle = atan2(direction.y, direction.x)
	rotation = angle - PI/2

func spawn():
	var spawnLocations = ["top", "bottom", "left", "right"]
	#Randomly choose spawn location
	var choice = spawnLocations[randi() % spawnLocations.size()]
	
	var screen_size = get_viewport_rect().size
	match choice:
		"top":
			position.x = (screen_size.x) / 2
			position.y = -20
			movement_angle = randf_range(0,PI)
		"bottom":
			position.x = (screen_size.x) / 2
			position.y = (screen_size.y) + 20
			movement_angle = randf_range(PI,2*PI)
		"left":
			position.x = 20
			position.y = (screen_size.y) / 2
			movement_angle = randf_range(3*PI/2,5*PI/2)
		"right":
			position.x = (screen_size.x) + 20
			position.y = (screen_size.y) / 2
			movement_angle = randf_range(PI/2,3*PI/2)
		_:
			pass

func shot():
	var pos = global_position
	emit_signal("is_shot", points, pos)
	despawn()

func despawn():
	position.x = 1000
	position.y = 1000

func _physics_process(delta):
	global_position += movement_vector.rotated(movement_angle) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	despawn()

func _on_body_entered(body):
	if body is Player:
		var player = body
		player.die()
