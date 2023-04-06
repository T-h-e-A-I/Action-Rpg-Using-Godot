extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var animatedSprite = $AnimatedSprite
# Called when the node enters the scene tree for the first time.

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Animate")

# Called every frame. 'delta' is the elapsed time since the previous frame.

		


func _on_AnimatedSprite_animation_finished():
	queue_free()
