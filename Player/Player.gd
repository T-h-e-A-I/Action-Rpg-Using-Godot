extends KinematicBody2D

const MAX_SPEED = 55
const ACCELERATION = 300
const FRICTION = 800
var health = 4
enum{
	MOVE,
	ROLL,
	ATTACK
	
}
var state
var velocity = Vector2.ZERO
var roll_velocity = Vector2.LEFT
var stats = PlayerStats
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $SwordPivot/SwordHitbox
onready var hurtbox = $HurtBox
onready var hurt = $AnimatedSprite/AudioStreamPlayer
onready var blink =$AnimationPlayer2
func _ready():
	blink.play("Stop")
	state = MOVE
	animationTree.active = true
	swordHitbox.knockback_vector = Vector2.LEFT
	hurtbox.knockback_vector = Vector2.LEFT
func _physics_process(delta):
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()


func move_state(delta):
	#	if Input.is_action_pressed("ui_right"):
#		velocity.x = 4
#	elif Input.is_action_pressed("ui_left"):
#		velocity.x = -4
#	elif Input.is_action_pressed("ui_up"):
#		velocity.y = -4
#	elif Input.is_action_pressed("ui_down"):
#		velocity.y = +4
#	else:
#		velocity.x = 0
#		velocity.y = 0
#better way:
	var input = Vector2.ZERO
	input.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	input.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input = input.normalized();
	if input != Vector2.ZERO:
		roll_velocity = input
		swordHitbox.knockback_vector = input
		hurtbox.knockback_vector = input
		animationTree.set("parameters/Idle/blend_position",input)
		animationTree.set("parameters/Run/blend_position",input)
		animationTree.set("parameters/Attack/blend_position",input)
		animationTree.set("parameters/Roll/blend_position",input)
		animationState.travel("Run")
#		if input.x < 0:
#			animationPlayer.play("RunLeft")
#		else:
#			animationPlayer.play("RunRight")
		velocity = velocity.move_toward(input*MAX_SPEED,ACCELERATION*delta)
	else:
		animationState.travel("Idle")
#		animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION*delta)
	velocity = move_and_slide(velocity)
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL
func attack_state():
	animationState.travel("Attack")
func roll_state():
	velocity = roll_velocity*MAX_SPEED
	animationState.travel("Roll")
	velocity = move_and_slide(velocity)
func attack_finished():
	state = MOVE
func roll_finished():
	state = MOVE

onready var hit = $AnimatedSprite

	


func _on_HurtBox_area_entered(area):
	hurt.play()
	stats.health -= 1
	hit.visible = true
	hit.frame = 0
	blink.play("Start")
	hit.play("default")
	
	


func _on_AnimatedSprite_animation_finished():
	hit.visible = false
	blink.play("Stop")





func _on_AudioStreamPlayer_finished():
	if stats.health <= 0:
		queue_free()# Replace with function body.
