extends Sprite # Very Big Boss Enemy script

export (Color) var blue = Color("#3f3fd4")
export (Color) var green = Color("#3fd43f")
export (Color) var red = Color("#d43f3f")
export (float) var speed = 0.3
export (float) var scale_factor = 2.2
export (float) var health = 3.0

onready var outline_sprite = $SpriteBorder
onready var prompt = $RichTextLabel
onready var prompt_text = prompt.text
# onready var health_bar = $HealthBar

# Add reference to wall for collision detection
onready var game_wall = get_node("/root/Main/Wall")
onready var player_health = get_node("/root/Main/PlayerHealth")

func _ready() -> void:
	prompt_text = PromptList.get_sentence_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))
	# Scale the enemy sprite and adjust prompt position
	scale = Vector2(scale_factor, scale_factor)
	# health_bar.max_value = health
	# health_bar.value = health
	
func _physics_process(_delta: float) -> void:
	global_position.x -= speed
	
	# Fixed collision check using rect_size
	if global_position.x <= game_wall.rect_global_position.x + game_wall.rect_size.x/2:
		# Boss takes all hearts except one
		for _i in range(player_health.current_health - 1):
			player_health.take_damage()
		queue_free()

func set_active():
	outline_sprite.scale = Vector2(1.2, 1.2)  # Make the outline slightly bigger than the original
	outline_sprite.modulate = Color(1.0, 0.0, 0.0)  # Set outline to red
	outline_sprite.show()  # Make sure the outline is visible when active


func get_prompt() -> String:
	return prompt_text
	
func set_next_character(next_character_index: int):
	var blue_text = get_bbcode_color_tag(blue) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var red_text = ""
	
	if next_character_index != prompt_text.length():
		red_text = get_bbcode_color_tag(red) + prompt_text.substr(next_character_index + 1, prompt_text.length() - next_character_index + 1) + get_bbcode_end_color_tag()
	prompt.parse_bbcode(set_center_tags(blue_text + green_text + red_text))
	
	# Calculate completion percentage and update health
	var completion_ratio = float(next_character_index) / float(prompt_text.length())
	var _damage = completion_ratio * health
	# health_bar.value = health - damage
	
	# Flash the boss when hit
	modulate = Color(2.0, 2.0, 2.0)
	yield(get_tree().create_timer(0.1), "timeout")
	modulate = Color(1.0, 1.0, 1.0)
	
func set_center_tags(string_to_center: String):
	return "[center]" + string_to_center + "[/center]"
	
func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"
	
func get_bbcode_end_color_tag() -> String:
	return "[/color]"
