extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone

var knockBack = Vector2.ZERO
var knockBackSpeed = 50
@export var MAX_SPEED = 30
@export var FRICTION = 0.5
@export var ACCELERATION = 300

var player_first_seen = true


enum {
	IDLE,
	WANDER,
	ALERT,
	CHASE
}

var state = IDLE

func _ready():
	$HealthLabel.text = str(stats.health)

func create_death_effect():
	var DeathEffect = load("res://Enemies/Effects/SlimeDeathEffect.tscn")
	var deathInstance = DeathEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(deathInstance)
	deathInstance.global_position = global_position
	

func _physics_process(delta):
	match state:
		IDLE:
			animationPlayer.play("Idle")
			velocity = velocity.lerp(Vector2.ZERO, FRICTION)
			seek_player()
			
	match state:
		WANDER:
			pass
	match state:
		ALERT:
			animationPlayer.play("Alert")
		
	match state:
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				if velocity.x < 0:
					animationPlayer.play("RunLeft")
				if velocity.x > 0:
					animationPlayer.play("RunRight")
					
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			
	move_and_slide()

func seek_player():
	if playerDetectionZone.can_see_player():
		if player_first_seen == true:
			player_first_seen = false
			state = ALERT
		else:
			state = CHASE

func end_alert():
	state = CHASE

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	$HealthLabel.text = str(stats.health)
	var direction = (position - area.owner.position).normalized()
	velocity = direction * knockBackSpeed
	

func _on_stats_no_health():
	create_death_effect()
	queue_free()
