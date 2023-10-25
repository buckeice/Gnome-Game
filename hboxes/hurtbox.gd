extends Area2D

@export_flags("SHOW", "HIDE") var show_hit = 1
@onready var timer = $Timer

var invincible = false

signal invincibility_started
signal invincibility_ended


func start_invincibility(duration):
	self.invincible = true
	emit_signal("invincibility_started")
	timer.start(duration)

func _on_area_entered(area):
	if show_hit == 1:
		var HitEffect = load("res://Enemies/Effects/EnemyHit.tscn")
		var hitInstance = HitEffect.instantiate()
		var world = get_tree().current_scene
		world.add_child(hitInstance)
		hitInstance.global_position = global_position
	


func _on_timer_timeout():
	self.invincible = false
	emit_signal("invincibility_ended")


func _on_invincibility_started():
	set_deferred("monitoring", false)


func _on_invincibility_ended():
	set_deferred("monitoring", true)
