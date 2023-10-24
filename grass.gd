extends StaticBody2D

const GrassEffect = preload("res://Tilesets/natural/effects/GrassEffect.tscn")

func create_grass_effect():
	var grassInstance = GrassEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(grassInstance)
	grassInstance.global_position = global_position


func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
