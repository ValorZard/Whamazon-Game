extends Control


onready var health_label = $Overlay/HBoxContainer/VBoxContainer/Health/HealthLabel
onready var bar = $Overlay/HBoxContainer/VBoxContainer/Health/Gauge/Health
onready var tween = $Overlay/Tween
onready var speed_label = $Overlay/HBoxContainer/VBoxContainer/SpeedLabel
onready var timer_label = $Overlay/HBoxContainer/TextDisplay

var ms = 0
var s = 0
var m = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_labels():
	speed_label.text = "SPEED:" + str(-(get_parent().horizontal_speed))
	health_label.text = "HP:" + str(get_parent().health)
	
	bar.value = get_parent().health * 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update_labels()
