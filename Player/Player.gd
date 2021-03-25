extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Player

# horizontal movement variables
var linear_accel : float = 1
var linear_decel : float = 0.1
var max_horizontal_speed : int = 30

var horizontal_speed : float = 0

# vertical movement variables
var gravity : float = 3
var terminal_velocity : float = 50 # max speed of falling

# main velocity
var linear_velocity : Vector3 = Vector3()

# turning variables
var turn_force : float = 0.0

var turn_accel : float = 0.01
var turn_decel : float = 0.5
var max_turn : float = 0.03

# durability variables
var health : int = 10
var max_health : int = 10

# extra data stuff
var spawn_data : Transform

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_data = get_global_transform()

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
			horizontal_speed -= linear_accel
	
		# Brake / reverse
		if (Input.is_action_pressed("player_back")):
			horizontal_speed += linear_accel
		
		horizontal_speed = clamp(horizontal_speed, -max_horizontal_speed, max_horizontal_speed)
	else:
		# linear interpolation
		# The basic idea is that you want to transition from A to B. 
		# A value t, represents the states in-between.
		# interpolation = A + (B - A) * t
		horizontal_speed = horizontal_speed + (0 - horizontal_speed) * linear_decel
	
	
	linear_velocity = forward_vector * horizontal_speed

func update_gravity():
	if not is_on_floor():
		if(linear_velocity.y > -terminal_velocity):
			linear_velocity.y -= gravity
		elif(linear_velocity.y < -terminal_velocity):
			linear_velocity.y = -terminal_velocity
	else:
		linear_velocity.y = 0

func update_movement():
	linear_velocity = move_and_slide(linear_velocity)
	
	# Check for all collisions
	for i in range(get_slide_count() - 1):
		var collision = get_slide_collision(i)
		var collider = collision.collider
		
		if collider.is_in_group("Obstacles"):
			collider.do_damage(self)

# when hitting an enemy, we want a bit of knockback
func apply_knockback(strength : int):
	if(horizontal_speed <= 0):
		horizontal_speed += strength
	else:
		horizontal_speed -= strength

func check_if_dead():
	if health <= 0:
		respawn()

func respawn():
	transform = spawn_data
	health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	check_if_dead()
	
	turn_car()
	
	drive_car()
	
	update_gravity()
	
	update_movement()
	
	#print(self.transform)
	pass
