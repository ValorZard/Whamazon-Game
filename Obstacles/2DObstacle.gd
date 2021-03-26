extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Obstacle2D

export var damage : int = 10

export var health : int = 30
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Obstacles")

func check_if_dead():
	if health <= 0:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	check_if_dead()

