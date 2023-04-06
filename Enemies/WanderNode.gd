extends Node2D
export (int) var wander_range = 32
onready var start_position = global_position
onready var target_positon = global_position
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = $Timer 
func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range,wander_range),rand_range(-wander_range,wander_range))
	target_positon = start_position + target_vector

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func start_wander_timer(duration):
	timer.start(duration)
func get_time_left():
	return timer.time_left
func _on_Timer_timeout():
	update_target_position() # Replace with function body.
