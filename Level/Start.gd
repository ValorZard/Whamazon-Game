extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var start_button = $Start
onready var quit_button = $Quit

onready var overlay = get_parent().get_node('Level/Player/HUD')


func _ready():
	start_button.connect("pressed", self, "_start_pressed")
	quit_button.connect("pressed", self, "_quit_pressed")

func _start_pressed():
	self.visible = not self.visible
	get_tree().paused = false
	overlay.visible = not overlay.visible
	
	
func _quit_pressed():
	get_tree().quit()
	
