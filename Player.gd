extends CharacterBody2D

@export var speed = 80
@export var friction = 0.15
@export var acceleration = 1
var roll_vector = Vector2.DOWN
const roll_speed = 150


enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input

func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		
		ROLL:
			roll_state()
		
		ATTACK:
			attack_state()
	
func move_state():
	var direction = get_input()
	
	if direction != Vector2.ZERO:
		roll_vector = direction
		animationTree.set("parameters/Idle/blend_position", direction)
		animationTree.set("parameters/Run/blend_position", direction)
		animationTree.set("parameters/Attack/blend_position", direction)
		animationTree.set("parameters/Dodge/blend_position", direction)
		animationState.travel("Run")
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		animationState.travel("Idle")
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move()
	
	if Input.is_action_just_pressed("attack"):
		velocity = Vector2.ZERO
		state = ATTACK
		
	if Input.is_action_just_pressed("dodge"):
		state = ROLL
		
	
	
func attack_state():
	
	animationState.travel("Attack")
	
func move():
	move_and_slide()
	

func roll_state():
	velocity = velocity.lerp(roll_vector.normalized() * roll_speed, acceleration)
	animationState.travel("Dodge")
	move()
	
func roll_animation_finished():
	state = MOVE
	

func attack_animation_finished():
	state = MOVE
