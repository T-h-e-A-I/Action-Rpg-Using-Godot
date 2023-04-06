extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var MAX_SPEED = 40
var ACCELERATION = 500
var FRICTION  = 200
var hitBool
enum{
	IDLE,
	WANDER,
	CHASE,
	DEAD
}
var state = pick_new_state([IDLE,WANDER])
export var health = 3
# Called when the node enters the scene tree for the first time.
var knockback_velocity = Vector2.ZERO
var velocity = Vector2.ZERO
onready var bat = $AnimatedSprite
onready var effect = $AnimatedSprite2
onready var hitEffect = $AnimatedSprite3
onready var musicHit = $AnimatedSprite3/AudioStreamPlayer
onready var playerDetection = $PlayerDetectionZone
onready var playerAttack = $HurtBox/CollisionShape2D
onready var wanderCon = $WanderNode
onready var music = $AnimatedSprite2/AudioStreamPlayer
onready var blink = $AnimationPlayer

func _physics_process(delta):
	knockback_velocity = move_and_slide(knockback_velocity)
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO,FRICTION*delta)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO,FRICTION*delta)
			if wanderCon.get_time_left() == 0:
				state = pick_new_state([IDLE,WANDER])
				wanderCon.start_wander_timer(rand_range(1,3))
			seek_player()
		WANDER:
			seek_player()
			
			if wanderCon.get_time_left() == 0.1:
				state = pick_new_state([IDLE,WANDER])
				wanderCon.start_wander_timer(rand_range(1,3))
			if global_position.distance_to(wanderCon.target_positon) < 4:
				state = pick_new_state([IDLE,WANDER])
				wanderCon.start_wander_timer(rand_range(1,3))
			var direction = global_position.direction_to(wanderCon.target_positon)
			velocity = velocity.move_toward(direction*MAX_SPEED,ACCELERATION*delta)
		CHASE:
			var player = playerDetection.player
			if playerDetection.player_seen():
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction*MAX_SPEED,ACCELERATION*delta)
			else:
				state = pick_new_state([IDLE,WANDER])
		DEAD:
			playerAttack.disabled = true
			velocity = Vector2.ZERO
			knockback_velocity = Vector2.ZERO
			
	bat.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func create_grass_effect():
#	var GrassEffect = load("res://Effects/GrassEffect.tscn")
#	var grassEffect = GrassEffect.instance()
#	var world = get_tree().current_scene
#	world.add_child(grassEffect)
#	grassEffect.global_position = global_position
#
#func _on_HurtBox_area_entered(area):
#	create_grass_effect()
#	queue_free()
func pick_new_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
func seek_player():
	if playerDetection.player_seen():
		state = CHASE
	
func _on_Hitbox_area_entered(area):
	blink.play("Start")
	musicHit.play()
	hitBool  = true
	hitEffect.visible = true
	hitEffect.frame = 0
	hitEffect.play("Animate")
	health = health - 1
	knockback_velocity =  area.knockback_vector*130
	if(health == 0):
		music.play()
		state = DEAD
		playerAttack.set_deferred("disabled",true)
		velocity = Vector2.ZERO
		bat.visible = false
		effect.visible = true
		effect.frame = 0
		effect.play("Animation")
	
		
	



func _on_AnimatedSprite2_animation_finished():
	queue_free() # Replace with function body.


func _on_AnimatedSprite3_animation_finished():
	hitEffect.visible = false 
	# Replace with function body.





func _on_HurtBox_area_entered(area):
	knockback_velocity = area.knockback_vector*130# Replace with function body.


func _on_AnimatedSprite2_visibility_changed():
	knockback_velocity = Vector2.ZERO
	velocity = Vector2.ZERO # Replace with function body.
