extends Control

onready var health_label = $Overlay/HBoxContainer/VBoxContainer/Health/HealthLabel
onready var bp_bar = $Overlay/HBoxContainer3/VBoxContainer/BPGaugeSped/Node2D/BPFill
onready var tween = $Overlay/Tween
onready var speed_label = $Overlay/HBoxContainer3/SpeedLabel
onready var timer_label = $Overlay/HBoxContainer2/VBoxContainer/Timer


var timer : int = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect('health_changed', self, 'update_health')

func _process(delta):
	timer += delta
	timer_label.set_text(str(floor(timer / 60)).pad_zeros(2) + ":" + str(stepify(fmod(timer, 60.0), 0.01)).pad_zeros(2))

func update_speed():
	speed_label.text = "SPEED:" + str(-(get_parent().horizontal_speed))
	
func update_health(new_health):
	health_label.text = "PACKAGE HEALTH:" + str(new_health)
	#tween.interpolate_property(bar, 'value', bar.value, new_health, .1)
	#tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update_speed()

