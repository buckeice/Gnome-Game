extends Node

@export var maxHealth = 1
@onready var health = maxHealth:
	get:
		return health
	set(value):
		health = value
		if health <= 0:
			emit_signal("no_health")



signal no_health
