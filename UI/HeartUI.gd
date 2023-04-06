extends Control


onready var empty = $TextureRect
onready var full = $TextureRect2

func _physics_process(delta):
	var health = PlayerStats.health
	full.rect_size.x = health*15
	if health == 0:
		full.visible = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.

