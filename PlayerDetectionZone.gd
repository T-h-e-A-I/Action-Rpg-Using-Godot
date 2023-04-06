extends Area2D
var player = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func player_seen():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body # Replace with function body.


func _on_PlayerDetectionZone_body_exited(body):
	player = null # Replace with function body.
