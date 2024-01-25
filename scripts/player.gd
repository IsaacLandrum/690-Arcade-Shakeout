extends CharacterBody2D

signal bullet_shot(bullet)

# export variables
@export var acceleration := 10.0
@export var max_speed := 350
@export var rotation_speed := 225.0

@onready var muzzle = $Muzzle

var bullet_scene = preload("res://scenes/bullet.tscn")

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot_bullet()

func _physics_process(delta):
	
	# get input vector from keybinds
	var input_vector := Vector2(0, Input.get_axis("move_forward", "move_backward"))
	velocity += input_vector.rotated(rotation) * acceleration
	# limit velocity of player
	velocity = velocity.limit_length(max_speed)
	
	# rotate right
	if Input.is_action_pressed("rotate_right"):
		# multiply by delta so frame rate independent
		rotate(deg_to_rad(rotation_speed * delta))
	# rotate left
	if Input.is_action_pressed("rotate_left"):
		# multiply by delta so frame rate independent
		rotate(deg_to_rad(-rotation_speed * delta))
	
	# if no keys are being pressed slowly reduce velocity to zero
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	move_and_slide()
	
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

func shoot_bullet():
	var b = bullet_scene.instantiate()
	b.global_position = muzzle.global_position
	b.rotation = rotation
	emit_signal("bullet_shot", b)



