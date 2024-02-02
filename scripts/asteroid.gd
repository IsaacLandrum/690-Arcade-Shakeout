class_name  Asteroid extends Area2D

signal exploded(pos, size)
@onready var player = get_player()

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
	
	rotation = randf_range(0,2*PI)

func _physics_process(delta):
	
	
	
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
	#checks for unique sprite Name as leech and runs specific leech movement
	if $LeechSprite2D:
			delay_rot_to($LeechSprite2D.global_position,player.global_position,PI,delta)
			global_position += player.global_position.rotated(rotation).normalized() * speed*2 * delta
	else:
		global_position += movement_vector.rotated(rotation) * speed * delta
		

func explode():
	emit_signal("exploded", global_position, size, points)
	queue_free()


#function that turns leeches torwards player
func delay_rot_to(origin,target,rot_sp,delta):
	#vector between object and target
	var direction = target - origin 
	#angle of vector
	var angle = direction.angle()
	var gr = global_rotation
	#angle_delta serves as a limiter of how much the object rotates within this frame
	var angle_delta= rot_sp*delta
	#get complete rotation to ship
	angle = lerp_angle(gr,angle,1.0)
	#clamp is used to limit the rotation to what is allowed in the frame
	angle = clamp(angle,gr-angle_delta,gr+angle_delta)
	global_rotation = angle
	
func get_player():
	var nodes = get_tree().get_nodes_in_group("Player")
	if len(nodes) > 0:
		return nodes[0]
	push_error("The player is missing...")
	
func _on_body_entered(body):
	if body is Player:
		var player = body
		player.die()

