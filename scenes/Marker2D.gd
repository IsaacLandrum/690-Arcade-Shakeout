extends Marker2D
#marker created to possibly designate origin of bullets plust sprite manipulation
#rotation speed in radians per second
var rotation_speed := 2*PI
#function that handles delayed rotation from any object to a specified target
func delay_rot_to(target,rot_sp,delta):
	#vector between object and target
	var direction = target - $Sprite2D.global_position 
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
	
func _process(delta):
	#Section that handles
	delay_rot_to(get_global_mouse_position(),rotation_speed,delta)

