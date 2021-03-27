extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var start_button = $Respawn
onready var quit_button = $Quit

onready var overlay = get_parent().get_node('HUD')


func _ready():
	start_button.connect("pressed", self, "_start_pressed")
	quit_button.connect("pressed", self, "_quit_pressed")

func _start_pressed():
	self.visible = not self.visible
	get_tree().paused = false
	overlay.visible = not overlay.visible
	get_parent().respawn()

func set_score():
	$ScoreLabel.text = "Score: " + str(get_parent().health)

func _quit_pressed():
	get_tree().quit()
