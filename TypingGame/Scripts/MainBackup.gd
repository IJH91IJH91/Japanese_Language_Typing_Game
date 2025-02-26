extends Node2D # Main script

var Enemy = preload("res://Enemy.tscn")

onready var enemy_container = $EnemyContainer
onready var spawn_container = $SpawnContainer
onready var spawn_timer = $SpawnTimer

var active_enemy = null
var current_letter_index: int = -1

func _ready() -> void:
	randomize()
	spawn_timer.start()
	spawn_enemy()

func find_new_active_enemy(typed_character: String):
	var closest_enemy = null
	var min_distance = INF  # Start with a large number

	for enemy in enemy_container.get_children():
		var prompt = enemy.get_prompt()
		var next_character = prompt.substr(0, 1)

		if next_character == typed_character:
			var distance = enemy.global_position.x  # X position (closer to left is lower value)
			if distance < min_distance:  
				min_distance = distance
				closest_enemy = enemy

	if closest_enemy:
		print("New active enemy:", closest_enemy.get_prompt())
		active_enemy = closest_enemy
		current_letter_index = 1
		active_enemy.set_next_character(current_letter_index)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = PoolByteArray([typed_event.unicode]).get_string_from_utf8()

		if active_enemy == null:
			find_new_active_enemy(key_typed)
		else:
			var prompt = active_enemy.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)
			if key_typed == next_character:
				print("typed: %s" % key_typed)
				current_letter_index += 1
				active_enemy.set_next_character(current_letter_index)
				if current_letter_index == prompt.length():
					print("done")
					current_letter_index = -1
					active_enemy.queue_free()
					active_enemy = null
			else:
				print("wrong letter %s , right letter is %s" % [key_typed, next_character])
			

func _on_SpawnTimer_timeout():
	spawn_enemy()
	
func spawn_enemy():
	var enemy_instance = Enemy.instance()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawns[index].global_position
