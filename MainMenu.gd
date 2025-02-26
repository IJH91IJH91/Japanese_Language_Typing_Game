extends Control

# This will be the scene that you load when the player clicks "Start"
export (PackedScene) var game_scene: PackedScene

func _ready():
	# Connect buttons
	$StartButton.connect("pressed", self, "_on_start_button_pressed")
	$QuitButton.connect("pressed", self, "_on_quit_button_pressed")

# Called when the "Start Game" button is pressed
func _on_start_button_pressed():
	print("Start Game pressed!")
	# Change the scene to the game level scene
	get_tree().change_scene_to(game_scene)

# Called when the "Quit" button is pressed
func _on_quit_button_pressed():
	print("Quit Game pressed!")
	# Quit the game
	get_tree().quit()
