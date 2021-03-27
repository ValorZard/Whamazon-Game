extends VehicleBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var car_mesh : MeshInstance

var engine_power : float = -42
var engine_range : float = 10

var steer_range : float = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	engine_force = -engine_power
	car_mesh = get_node("SM_TCar_01/RootNode/SM_TCar_01")
	# car_mesh.material_override.albedo_color = Color.from_hsv(rand_range(0.0, 6.0), 1.0, 1.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	engine_force = rand_range(engine_power - engine_range, engine_power + engine_range)
	steering = 0
	pass
