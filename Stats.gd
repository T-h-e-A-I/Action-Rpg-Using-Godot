extends Node2D
signal no_health
signal health_change
export(int) var maxhealth = 4
onready var health = maxhealth setget set_health

func set_health(value):
	health = value
	if health == 0:
		emit_signal("no_health")
	emit_signal("health_change")




# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
