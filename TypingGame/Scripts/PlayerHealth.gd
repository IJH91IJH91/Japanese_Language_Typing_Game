extends Node

signal health_changed(new_health)
signal game_over

var max_health = 5
var current_health = 5

func _ready():
	current_health = max_health
	emit_signal("health_changed", current_health)

func take_damage():
	current_health -= 1
	emit_signal("health_changed", current_health)
	
	if current_health <= 0:
		emit_signal("game_over")

func reset():
	current_health = max_health
	emit_signal("health_changed", current_health)
