extends RigidBody
var camera
var rotate_pulse = Vector3(0,0,0)
var new_angular_velocity = Vector3(0,0,0)
var roll_velocity = 0
var roll_vector = Vector3(0,0,0)
var linear_thrust = Vector3(0,0,0)
var spin = Basis()
var thrust_factor = 10
var tilt = Basis()
var roll = Basis()
var zero_vector = Vector3(0,0,0)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = get_node("Camera")
	linear_damp = 0.6
	angular_damp = 0.75

func _process(delta):
	#set_angular_velocity(new_angular_velocity + roll_vector)
	roll_vector *= 0.1
	if Input.is_action_pressed("thrust_up"):
		linear_thrust[1] = 1
	elif Input.is_action_pressed("thrust_down"):
		linear_thrust[1] = -1
	else:
		linear_thrust[1] = 0
	if Input.is_action_pressed("thrust_left"):
		linear_thrust[0] = -1
	elif Input.is_action_pressed("thrust_right"):
		linear_thrust[0] = 1
	else:
		linear_thrust[0] = 0
	if Input.is_action_pressed("thrust_forward"):
		linear_thrust[2] = -1
	elif Input.is_action_pressed("thrust_reverse"):
		linear_thrust[2] = 1
	else:
		linear_thrust[2] = 0
	if (linear_thrust != zero_vector):
		var pos = self.translation
		var rot = self.transform.translated(-pos)		
		var tilt = transform.basis.x
		var spin = transform.basis.y
		var roll = transform.basis.z
		linear_thrust = tilt * linear_thrust[0] + spin * linear_thrust[1] + roll * linear_thrust[2]
		apply_impulse(zero_vector, linear_thrust * delta * thrust_factor)
	if Input.is_action_pressed("roll_left"):
		roll_vector = transform.basis.z
		print("roll left")
	elif Input.is_action_pressed("roll_right"):
		roll_vector = -transform.basis.z
		print("roll right")
	
	

func _input(event):
	if event is InputEventMouseMotion:
		var speed = event.speed / 3600
		tilt = transform.basis.x
		var basis = transform.basis.z
		if Input.is_action_pressed("hold_roll"):
			basis = transform.basis.y
			spin = transform.basis.z
			roll = transform.basis.y
		else:
			spin = transform.basis.y
			roll = transform.basis.z
		new_angular_velocity = (Vector3(tilt.x, tilt.y, tilt.z) * speed[0]) + (Vector3(spin.x, spin.y, spin.z) * speed[1])
		apply_impulse(basis, -new_angular_velocity/10)
		apply_impulse(-basis, new_angular_velocity/10)
	

func _on_Player_body_entered( body ):
	print("entered")
