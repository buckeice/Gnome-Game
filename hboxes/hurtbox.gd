extends Area2D

@export_flags("SHOW", "HIDE") var show_hit = 1



func _on_area_entered(area):
	if show_hit == 1:
		var HitEffect = load("res://Enemies/Effects/EnemyHit.tscn")
		var hitInstance = HitEffect.instantiate()
		var world = get_tree().current_scene
		world.add_child(hitInstance)
		hitInstance.global_position = global_position
	
