extends Control

#onready var health_label = $Overlay/HBoxContainer/VBoxContainer/Health/HealthLabel
onready var bp_bar = $BPGaugeSped/Node2D/BPFill
onready var tween = $Tween
onready var speed_label = $SpeedLabel
onready var timer_label = $Timer
onready var driver_icon = $DriverIcon
onready var needle = $BPGaugeSped/Needle

var timer : float = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect('health_changed', self, 'update_health')
	get_parent().connect('bp_changed', self, 'update_bp')

func _process(delta):
	timer += delta
	timer_label.set_text(("%02d" % floor(timer / 60)) + ":" + ("%2.2f" % fmod(timer, 60.0)).pad_zeros(2))

func update_speed():
	speed_label.text = "SPEED:" + str(-(get_parent().horizontal_speed))
	needle.rect_rotation = 7.5+(abs(get_parent().horizontal_speed)/30.0*263.0)
	
func update_health(updated_health):
	pass

func update_bp(updated_bp):
	tween.interpolate_property(bp_bar, 'value', bp_bar.value, updated_bp, .2)
	tween.start()
	
	if updated_bp < 30:
		driver_icon.texture = load("res://Assets/Overlay/portrait1.png")
	elif updated_bp > 30 and updated_bp < 70:
		driver_icon.texture = load("res://Assets/Overlay/portrait2.png")
	elif updated_bp > 70:
		driver_icon.texture = load("res://Assets/Overlay/portrait3.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update_speed()

