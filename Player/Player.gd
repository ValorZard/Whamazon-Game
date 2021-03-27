extends KinematicBody

signal health_changed(new_health)
signal bp_changed(new_bp)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Player

# game state stuff
var is_drifting : bool = false

# horizontal movement variables
export var linear_accel : float = 1
export var linear_decel : float = 0.1
export var max_horizontal_speed : int = 30

# main horizontal movement var
export var horizontal_speed : float = 0

# drifting specific speed
export var drift_linear_accel : float = 0.75
export var drift_linear_decel : float = 0.1
export var drift_max_horizontal_speed : int = 25

# vertical movement variables
export var gravity : float = 3
export var terminal_velocity : float = 50 # max speed of falling

# main velocity
export var linear_velocity : Vector3 = Vector3()

# turning variables
export var turn_force : float = 0.0

export var turn_accel : float = 0.01
export var turn_decel : float = 0.5
export var max_turn : float = 0.03

# drifting specific turning
export var drift_turn_accel : float = 0.05
export var drift_turn_decel : float = 0.1

export var drift_max_turn : float = 0.15

# durability variables
export var health : int = 100
export var max_health : int = 100
export var boiling_point : float = 0
export var max_boiling_point : float = 100

# extra data stuff
var spawn_data : Transform

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_data = get_global_transform()
	emit_signal('health_changed', health)
	emit_signal('bp_changed', boiling_point)

func check_if_drifting():
	is_drifting = Input.is_action_pressed("drift")

func turn_car():
	var accel : float = 0
	var decel : float = 0
	var current_max_turn : float = 0
	
	if(is_drifting):
		accel = drift_turn_accel
		decel = drift_turn_decel
		current_max_turn = drift_max_turn
	else:
		accel = turn_accel
		decel = turn_decel
		current_max_turn = max_turn
	
	# Steering left and right
	if(Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right")):
		if (Input.is_action_pressed("player_left")):
			turn_force += accel
		if (Input.is_action_pressed("player_right")):
			turn_force -= accel
		
		turn_force = clamp(turn_force, -current_max_turn, current_max_turn)
	else:
		# linear interpolation
		# The basic idea is that you want to transition from A to B. 
		# A value t, represents the states in-between.
		# interpolation = A + (B - A) * t
		turn_force = turn_force + (0 - turn_force) * decel
	# Rotate around y-axis
	rotate(get_global_transform().basis.y, turn_force) 
	
	pass

func drive_car():
	var forward_vector = get_global_transform().basis.z	
	
	var accel : float = 0
	var decel : float = 0
	var max_speed : float = 0
	
	if(is_drifting):
		accel = drift_linear_accel
		decel = drift_linear_decel
		max_speed = drift_max_horizontal_speed
	else:
		accel = linear_accel
		decel = linear_decel
		max_speed = max_horizontal_speed
	
	# if is driving
	if (Input.is_action_pressed("player_forward") or Input.is_action_pressed("player_back")):
		# Drive forward
		if (Input.is_action_pressed("player_forward")):
			horizontal_speed -= accel
	
		# Brake / reverse
		if (Input.is_action_pressed("player_back")):
			horizontal_speed += accel
		
		horizontal_speed = clamp(horizontal_speed, -max_speed, max_speed)
	else:
		# linear interpolation
		# The basic idea is that you want to transition from A to B. 
		# A value t, represents the states in-between.
		# interpolation = A + (B - A) * t
		horizontal_speed = horizontal_speed + (0 - horizontal_speed) * decel
	
	
	linear_velocity = forward_vector * horizontal_speed

func update_gravity():
	if not is_on_floor():
		if(linear_velocity.y > -terminal_velocity):
			linear_velocity.y -= gravity
		elif(linear_velocity.y < -terminal_velocity):
			linear_velocity.y = -terminal_velocity
	else:
		linear_velocity.y = 0

func update_movement(delta):
	linear_velocity = move_and_slide(linear_velocity)
	
	# Check for all collisions
	for i in range(get_slide_count() - 1):
		var collision = get_slide_collision(i)
		var collider = collision.collider
		
		if collider.is_in_group("Obstacles"):
			boiling_point += 20
			if boiling_point > max_boiling_point:
				boiling_point = max_boiling_point
			health -= collider.damage
			collider.health -= 10
			apply_knockback(70)
			emit_signal('health_changed', health)
		elif collider.is_in_group("End"):
			win_game()
		else:
			if boiling_point > 0:
				boiling_point -= 5*delta
		emit_signal('bp_changed', boiling_point)
	

# when hitting an enemy, we want a bit of knockback
func apply_knockback(strength : int):
	if(horizontal_speed <= 0):
		horizontal_speed += strength
	else:
		horizontal_speed -= strength

func check_if_dead():
	if health <= 0:
		game_over()

func game_over():
	$HUD.visible = not $HUD.visible
	get_tree().paused = true
	$GameOver.visible = not $GameOver.visible

func win_game():
	$HUD.visible = not $HUD.visible
	get_tree().paused = true
	$WinScreen.visible = not $WinScreen.visible
	$WinScreen.set_score()


func respawn():
	transform = spawn_data
	health = max_health
	boiling_point = 0
	
	emit_signal('bp_changed', boiling_point)
	emit_signal('health_changed', health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	check_if_dead()
	
	check_if_drifting()
	
	turn_car()
	
	drive_car()
	
	update_gravity()
	
	update_movement(delta)
	
	#print(self.transform)
	pass
