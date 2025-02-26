extends Node2D # Main script
var Enemy = preload("res://Enemy.tscn")
var BiggerEnemy = preload("res://BiggerEnemy.tscn")
var BossEnemy = preload("res://BossEnemy.tscn")

onready var enemy_container = $EnemyContainer
onready var spawn_container = $SpawnContainer
onready var spawn_timer = $SpawnTimer
onready var boss_timer = $BossTimer
onready var bigger_enemy_timer = $BiggerEnemyTimer
onready var player_health = $PlayerHealth
onready var heart_container = $HeartContainer
onready var game_over_panel = $GameOverPanel

var active_enemy = null
var current_letter_index: int = -1
var boss_spawn_chance = 0.2
var bigger_enemy_spawn_chance = 0.6
var boss_defeated = 0
var game_over = false

func _ready() -> void:
	randomize()
	
	# Connect health system signals
	player_health.connect("health_changed", self, "_on_health_changed")
	player_health.connect("game_over", self, "_on_game_over")
	
	# Initialize hearts
	update_hearts(player_health.current_health)
	
	# Start game
	start_game()

func start_game():
	game_over = false
	boss_defeated = 0
	player_health.reset()
	
	# Clear any existing enemies
	for enemy in enemy_container.get_children():
		enemy.queue_free()
	
	# Hide game over panel
	game_over_panel.visible = false
	
	# Start timers
	spawn_timer.start()
	bigger_enemy_timer.start()
	boss_timer.start()
	
	# Spawn first enemy
	spawn_enemy()

func _on_health_changed(new_health):
	update_hearts(new_health)

func update_hearts(count):
	# Update heart display
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i)
		heart.visible = i < count

func _on_game_over():
	game_over = true
	
	# Stop all timers
	spawn_timer.stop()
	bigger_enemy_timer.stop()
	boss_timer.stop()
	
	# Show game over panel
	game_over_panel.visible = true
	game_over_panel.get_node("ScoreLabel").text = "Bosses Defeated: " + str(boss_defeated)

func find_new_active_enemy(typed_character: String):
	if game_over:
		return
		
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
	if game_over:
		# Check for restart input
		if event is InputEventKey and event.is_pressed() and event.scancode == KEY_SPACE:
			start_game()
		return
		
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
					
					# Check if the defeated enemy was a boss
					if active_enemy and active_enemy.filename == BossEnemy.resource_path:  # Null check here!
						boss_defeated += 1
						print("Boss defeated! Total: ", boss_defeated)
					
					# Ensure we don't interact with the enemy after it’s been freed
					if active_enemy:
						active_enemy.queue_free()
					active_enemy = null
			else:
				print("wrong letter %s , right letter is %s" % [key_typed, next_character])

			
func _on_SpawnTimer_timeout():
	if not game_over:
		spawn_enemy()
	
func _on_BiggerEnemyTimer_timeout():
	if not game_over and randf() <= bigger_enemy_spawn_chance:
		spawn_bigger_enemy()
	
func _on_BossTimer_timeout():
	if not game_over and randf() <= boss_spawn_chance:
		spawn_boss_enemy()
	
func spawn_enemy():
	var enemy_instance = Enemy.instance()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawns[index].global_position
	
func spawn_bigger_enemy():
	var enemy_instance = BiggerEnemy.instance()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawns[index].global_position
	
func spawn_boss_enemy():
	var enemy_instance = BossEnemy.instance()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawns[index].global_position
