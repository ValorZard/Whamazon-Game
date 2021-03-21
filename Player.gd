extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var linear_accel : float = 1
var linear_decel : float = 0.1
var max_speed : int = 30

var speed : float = 0
var linear_velocity : Vector3 = Vector3()

var turn_force : float = 0.0

var turn_accel : float = 0.01
var turn_decel : float = 0.5
var max_turn : float = 0.03

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func turn_car():
	
	# Steering left and right
	if(Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right")):
		if (Input.is_action_pressed("player_left")):
			turn_force += turn_accel
		if (Input.is_action_pressed("player_right")):
			turn_force -= turn_accel
		
		turn_force = clamp(turn_force, -max_turn, max_turn)
	else:
		# linear interpolation
		# The basic idea is that you want to transition from A to B. 
		# A value t, represents the states in-between.
		# interpolation = A + (B - A) * t
		turn_force = turn_force + (0 - turn_force) * turn_decel
	# Rotate around y-axis
	rotate(get_global_transform().basis.y, turn_force) 
	
	pass

func drive_car():
	var forward_vector = get_global_transform().basis.z	

	# if is driving
	if (Input.is_action_pressed("player_forward") or Input.is_action_pressed("player_back")):
		# Drive forward
		if (Input.is_action_pressed("player_forward")):
			speed -= linear_accel
	
		# Brake / reverse
		if (Input.is_action_pressed("player_back")):
			speed += linear_accel
		
		speed = clamp(speed, -max_speed, max_speed)
	else:
		# linear interpolation
		# The basic idea is that you want to transition from A to B. 
		# A value t, represents the states in-between.
		# interpolation = A + (B - A) * t
		speed = speed + (0 - speed) * linear_decel
	
	
	linear_velocity = forward_vector * speed
	
	move_and_slide(linear_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	turn_car()
	
	drive_car()
	
	#print(self.transform)
	pass
