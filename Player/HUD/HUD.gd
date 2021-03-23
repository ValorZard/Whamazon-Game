extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_labels():
	$CanvasLayer/SpeedLabel.text = "Speed:" + str(-(get_parent().horizontal_speed))
	$CanvasLayer/HealthLabel.text = "Health:" + str(get_parent().health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update_labels()
